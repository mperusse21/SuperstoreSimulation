-- Orders
-- when order placed: check if any warehouse has enough quantity, add the order, update quantity
CREATE OR REPLACE PACKAGE orders_package AS
    PROCEDURE add_order(vorder IN orders_typ);
    PROCEDURE delete_order(vorderid IN NUMBER);
    FUNCTION get_order (vorderid NUMBER, vproductid NUMBER)
        RETURN orders_typ;
    TYPE product_id_varray IS VARRAY(100) OF NUMBER;
    FUNCTION get_all_products(vorderid NUMBER)
        RETURN product_id_varray;
    FUNCTION get_max_inventory (vproductid NUMBER)
        RETURN NUMBER;
    FUNCTION validate_order (vproductid NUMBER, quantity NUMBER)
        RETURN VARCHAR2;
FUNCTION get_customer_orders (vcustomerid NUMBER)
        RETURN SYS_REFCURSOR;
    ORDER_NOT_FOUND EXCEPTION;
    OUT_OF_STOCK EXCEPTION;
END orders_package;
/

CREATE OR REPLACE PACKAGE BODY orders_package AS 
PROCEDURE add_order (
    vorder IN orders_typ
) AS
    vorder_id NUMBER(5) := vorder.OrderId;
    BEGIN
    -- if there is not enough stock in any warehouse raises an exception
    IF validate_order(vorder.ProductId, vorder.Quantity) = 'false' THEN
        RAISE OUT_OF_STOCK;
    END IF;
    
    -- Handles when JDBC id is 0 (or null)
    IF vorder_id = 0 THEN
        vorder_id := NULL;
    END IF;
    
    INSERT INTO Orders 
        VALUES (
        -- If orderId is null one will be generated
                vorder_id,
                vorder.ProductId,
                vorder.CustomerId,
                vorder.StoreId, 
                vorder.Quantity, 
                vorder.Price,
                vorder.OrderDate
        );
    END;
    
-- takes an orderid and deletes all rows with the orderid. (if it has multiple products they will all be deleted)
PROCEDURE delete_order (
    vorderid IN NUMBER
) IS
    BEGIN
    DELETE FROM Orders WHERE OrderId = vorderid;
    IF SQL%NOTFOUND THEN
        RAISE ORDER_NOT_FOUND;
    END IF;
    END;
    
-- Gets an order with a certain id and product (example order 1 apple)
FUNCTION get_order (vorderid IN NUMBER, vproductid IN NUMBER)
    RETURN orders_typ AS
        vcustomerid      NUMBER(5);
        vstoreid         NUMBER(5);
        vquantity        NUMBER(5,0);
        vprice           NUMBER (10,2);
        vorderdate       DATE;
        vorder orders_typ;
    BEGIN
        SELECT
            CustomerId,
            StoreId, 
            Quantity, 
            Price,
            OrderDate
        INTO
            vcustomerid,
            vstoreid,
            vquantity,
            vprice,
            vorderdate 
        FROM
            Orders
        WHERE
            OrderId = vorderid AND ProductId = vproductid;
        
        vorder := orders_typ(vorderid, vproductid, vcustomerid, vstoreid, vquantity, vprice, vorderdate);
        return vorder;
    END;
    
-- Gets an order with a certain id (returns an varray of orders)
FUNCTION get_all_products (vorderid IN NUMBER)
    RETURN product_id_varray AS
        products product_id_varray;
    BEGIN
        SELECT
            ProductId
        BULK COLLECT INTO
            products
        FROM
            Orders
        WHERE
            OrderId = vorderid;
        return products;
    END;
    
-- Gets and returns the max stock in any warehouse
FUNCTION get_max_inventory (vproductid NUMBER)
    RETURN NUMBER AS
        total_stock NUMBER(10,0);
    BEGIN
        SELECT
        -- Null is the same as having no stock
            NVL(MAX(Stock), 0)
        INTO
            total_stock
        FROM
            Inventory
        WHERE
            ProductId = vproductid;
        
        return total_stock;
    END;
-- Was originally a boolean but couldn't get the boolean to work in JDBC
FUNCTION validate_order (vproductid NUMBER, quantity NUMBER)
    RETURN VARCHAR2 AS
       max_stock NUMBER(10, 0);
    BEGIN
        max_stock := get_max_inventory(vproductid);
        
        IF max_stock < quantity THEN
            return 'false';
        ELSE
            return 'true';
        END IF;
    END;
    
FUNCTION get_customer_orders (vcustomerid NUMBER)
    RETURN SYS_REFCURSOR AS
        customer_orders SYS_REFCURSOR;
    BEGIN
        OPEN customer_orders FOR 
        SELECT 
            *
        FROM
            Orders
        WHERE
            CustomerId = vcustomerid; 
        RETURN customer_orders;
    END;

END orders_package;
/

CREATE OR REPLACE TRIGGER OrdersChange
AFTER INSERT OR UPDATE OR DELETE ON Orders
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.OrderId, 'INSERT', 'ORDERS', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.OrderId, 'DELETE', 'ORDERS', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.OrderId, 'UPDATE', 'ORDERS', SYSDATE);
    END IF;
END;
/

-- Reviews 

CREATE OR REPLACE PACKAGE reviews_package AS
    PROCEDURE add_review (vreview IN reviews_typ);
    PROCEDURE delete_review (vreviewid IN NUMBER);
    PROCEDURE update_score(vreview_id NUMBER, vscore NUMBER);
    PROCEDURE update_flag(vreview_id NUMBER, vflag VARCHAR2);
    PROCEDURE update_description(vreview_id NUMBER, vdescription VARCHAR2);
    FUNCTION get_review (vreviewid NUMBER)
        RETURN reviews_typ;
    FUNCTION get_average_score (vproductid NUMBER)
        RETURN NUMBER;
    FUNCTION get_flagged_customers 
        RETURN SYS_REFCURSOR;
    FUNCTION get_flagged_reviews 
        RETURN SYS_REFCURSOR;
    REVIEW_NOT_FOUND EXCEPTION;
END reviews_package;
/

CREATE OR REPLACE PACKAGE BODY reviews_package AS 
-- Adds a review using a review object
PROCEDURE add_review (
        vreview IN reviews_typ
    ) IS
    BEGIN
        INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description)     
            VALUES (
            -- If reviewid will be generated
                    vreview.ProductId,
                    vreview.CustomerId,
                    vreview.Score, 
                    vreview.Flag, 
                    vreview.Description
            );
    END;
    
-- takes an reviewid and deletes all rows with the reviewid.
PROCEDURE delete_review (
        vreviewid IN NUMBER
    ) IS
    BEGIN
        DELETE FROM Reviews WHERE ReviewId = vreviewid;
        IF SQL%NOTFOUND THEN
            RAISE REVIEW_NOT_FOUND;
        END IF;

    END delete_review;
    
-- Takes necessary information and updates a review score
PROCEDURE update_score(vreview_id NUMBER, vscore NUMBER) AS
    BEGIN
        UPDATE Reviews SET Score = vscore WHERE ReviewId = vreview_id;
        IF SQL%NOTFOUND THEN
            RAISE REVIEW_NOT_FOUND;
        END IF;
    END; 

-- Takes necessary information and updates a review flag
PROCEDURE update_flag(vreview_id NUMBER, vflag VARCHAR2) AS
    BEGIN
        UPDATE Reviews SET Flag = vflag WHERE ReviewId = vreview_id;
        IF SQL%NOTFOUND THEN
            RAISE REVIEW_NOT_FOUND;
        END IF;

    END; 
    
-- Takes necessary information and updates a review description
PROCEDURE update_description(vreview_id NUMBER, vdescription VARCHAR2) AS 
    BEGIN
        UPDATE Reviews SET Description = vdescription WHERE ReviewId = vreview_id;
        IF SQL%NOTFOUND THEN
            RAISE REVIEW_NOT_FOUND;
        END IF;

    END; 
    
-- Gets and returns a review object
FUNCTION get_review (vreviewid NUMBER)
    RETURN reviews_typ AS
        vproductid NUMBER(5);
        vcustomerid NUMBER(5);
        vscore NUMBER(1,0); 
        vflag NUMBER(1,0); 
        vdescription VARCHAR2(200);
        vreview reviews_typ;
    BEGIN
        SELECT
            ProductId,
            CustomerId,
            Score, 
            Flag, 
            Description
        INTO
            vproductid,
            vcustomerid,
            vscore, 
            vflag, 
            vdescription 
        FROM
            Reviews
        WHERE
            ReviewId = vreviewid;
        
        vreview := reviews_typ(vreviewid, vproductid, vcustomerid, vscore, vflag, vdescription);
        return vreview;

    END;
    
-- Gets the average review score for a specific product
FUNCTION get_average_score (vproductid NUMBER)
    RETURN NUMBER AS
        average_score NUMBER(3,2);
    BEGIN
        SELECT
            AVG(Score)
        INTO
            average_score
        FROM
            Reviews
        WHERE
            ProductId = vproductid;
            
        IF SQL%NOTFOUND THEN
            RAISE REVIEW_NOT_FOUND;
        END IF;
        
        return average_score;

    END;
    
-- Gets customers whose reviews have been flagged more than once
FUNCTION get_flagged_customers 
    RETURN SYS_REFCURSOR AS
        flagged_customers SYS_REFCURSOR;
    BEGIN
        OPEN flagged_customers FOR 
        SELECT 
            CustomerId,
            Firstname,
            Lastname,
            Email,
            Addressid 
        FROM
            Customers INNER JOIN Reviews
            USING (CustomerId)
        GROUP BY
            CustomerId,
            Firstname,
            Lastname,
            Email,
            Addressid 
        HAVING
            SUM(Flag) > 1; 
        RETURN flagged_customers;
    END;
    
-- Returns a cursor containing all reviews with one or more flags
FUNCTION get_flagged_reviews 
    RETURN SYS_REFCURSOR AS
        flagged_reviews SYS_REFCURSOR;
    BEGIN
        OPEN flagged_reviews FOR 
        SELECT 
            *
        FROM
            Reviews
        WHERE
            Flag > 0; 
        RETURN flagged_reviews;
    END;
    
END reviews_package;
/


CREATE OR REPLACE TRIGGER ReviewsChange
AFTER INSERT OR UPDATE OR DELETE ON Reviews
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.ReviewId, 'INSERT', 'REVIEWS', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.ReviewId, 'DELETE', 'REVIEWS', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.ReviewId, 'UPDATE', 'REVIEWS', SYSDATE);
    END IF;
END;
/

-- Warehouses

CREATE OR REPLACE PACKAGE warehouses_package AS
    PROCEDURE add_warehouse (vwarehouse IN warehouse_typ);
    PROCEDURE delete_warehouse (vwarehouseid IN NUMBER);
    PROCEDURE updatewarehousename(vwarehouseid NUMBER, vwarehousename IN VARCHAR2);
    FUNCTION get_warehouse (vwarehouseid NUMBER)
        RETURN warehouse_typ;
    WAREHOUSE_NOT_FOUND EXCEPTION;
END warehouses_package;
/

CREATE OR REPLACE PACKAGE BODY warehouses_package AS 
-- Takes a warehosue object and adds it to the database
PROCEDURE add_warehouse (
    vwarehouse IN warehouse_typ 
) IS
    BEGIN
        INSERT INTO Warehouses (WarehouseName, AddressId)   
            VALUES (
                    vwarehouse.WarehouseName,
                    vwarehouse.AddressId
            );
    END;

-- Deletes a warehouse (and all it's inventory) with a specified Id 
PROCEDURE delete_warehouse (
    vwarehouseid IN NUMBER
) IS
    BEGIN
        DELETE FROM Inventory WHERE WarehouseId = vwarehouseid;
        DELETE FROM Warehouses WHERE WarehouseId= vwarehouseid;
        
        IF SQL%NOTFOUND THEN
            RAISE WAREHOUSE_NOT_FOUND;
        END IF;

    END;
/*
-- updates a specified warehouses name
PROCEDURE updatewarehousename (
    vwarehouseid IN NUMBER,
    vwarehousename IN VARCHAR2
    ) IS
    BEGIN
        UPDATE Warehouses
        SET
            WarehouseName = vwarehousename
        WHERE
            WarehouseId = vwarehouseid;
        
        IF SQL%NOTFOUND THEN
            RAISE WAREHOUSE_NOT_FOUND;
        END IF;

    END;
    */

FUNCTION get_warehouse (vwarehouseid NUMBER)
    RETURN warehouse_typ AS
        vwarehousename VARCHAR2(20);
        vaddressid NUMBER(5);
        vwarehouse warehouse_typ;
    BEGIN
        SELECT
            WarehouseName,
            AddressId
        INTO
            vwarehousename,
            vaddressid
        FROM
            Warehouses
        WHERE
            WarehouseId = vwarehouseid;
        
        vwarehouse := warehouse_typ(vwarehouseid, vwarehousename, vaddressid);
        return vwarehouse;
    END;
END warehouses_package;
/

CREATE OR REPLACE TRIGGER WarehousesChange
AFTER INSERT OR UPDATE OR DELETE ON Warehouses
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.WarehouseId, 'INSERT', 'WAREHOUSES', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.WarehouseId, 'DELETE', 'WAREHOUSES', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.WarehouseId, 'UPDATE', 'WAREHOUSES', SYSDATE);
    END IF;
END;
/


-- Inventory

CREATE OR REPLACE PACKAGE inventory_package AS
    PROCEDURE updatestock(vwarehouseid IN NUMBER, vproductid IN NUMBER, vstock IN NUMBER);
    FUNCTION get_stock (vwarehouseid NUMBER, vproductid NUMBER)
        RETURN NUMBER;
    INVENTORY_NOT_FOUND EXCEPTION;
END inventory_package;
/

CREATE OR REPLACE PACKAGE BODY inventory_package AS 
    
-- Updates a warehouse's stock of a product
PROCEDURE updatestock (
    vwarehouseid IN NUMBER,
    vproductid IN NUMBER,
    vstock IN NUMBER
) IS
    BEGIN
        UPDATE Inventory
        SET
            Stock = vstock
        WHERE
            WarehouseId = vwarehouseid AND ProductId = vproductid;
        
        IF SQL%NOTFOUND THEN
            RAISE INVENTORY_NOT_FOUND;
        END IF;

    END;

-- Gets the stock of products in a warehouse
FUNCTION get_stock (vwarehouseid NUMBER, vproductid NUMBER)
    RETURN NUMBER AS
        vstock NUMBER(10,0);
    BEGIN
        SELECT
            Stock
        INTO
            vstock
        FROM
            Inventory
        WHERE
            WarehouseId = vwarehouseid AND ProductId = vproductid;
        
        IF SQL%NOTFOUND THEN
            RAISE INVENTORY_NOT_FOUND;
        END IF;
        
        return vstock;
    END;
    
END inventory_package;
/

CREATE OR REPLACE TRIGGER InventoryChange
AFTER INSERT OR UPDATE OR DELETE ON Inventory
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, ChangedId2, Action, TableChanged, DateModified)
        VALUES (:NEW.WarehouseId, :NEW.ProductId, 'INSERT', 'INVENTORY', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, ChangedId2, Action, TableChanged, DateModified)
        VALUES (:OLD.WarehouseId, :OLD.ProductId, 'DELETE', 'INVENTORY', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, ChangedId2, Action, TableChanged, DateModified)
        VALUES (:NEW.WarehouseId, :NEW.ProductId, 'UPDATE', 'INVENTORY', SYSDATE);
    END IF;
END;
/

-- DROP TRIGGER InventoryChange;

/* Testing 


 Got rid of all these, might re-add
    EXCEPTION
        WHEN ORDER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order with this id found');
        

--Function that returns all the Product Ids that are in a certain order 
FUNCTION get_all_order_products(vorderid NUMBER)
    RETURN products_id_varray IS
    product_id products_id_varray;
    BEGIN
        SELECT
            ProductId 
        BULK COLLECT INTO 
            product_id 
        FROM 
            Orders 
        WHERE 
            OrderId = vorderid;
        
        IF product_id.COUNT = 0 THEN
                RAISE ORDER_NOT_FOUND;
        END IF;
        
        RETURN product_id;
    END ;
    
    -- Gets the number of times a product was ordered
FUNCTION get_times_ordered (vproductid NUMBER)
    RETURN NUMBER AS
        times_ordered NUMBER(10);
    BEGIN
        SELECT
            COUNT(*)
        INTO
            times_ordered
        FROM
            Orders
        WHERE
            ProductId = vproductid;
        
        IF times_ordered = 0 THEN
            RAISE ORDER_NOT_FOUND;
        END IF;
        
        return times_ordered;
    END;

-- Adds inventory for a specific product in a specific warehouse from an object
PROCEDURE add_inventory (
    vinventory IN inventory_typ  
    ) IS
    BEGIN
    INSERT INTO Inventory   
        VALUES (
                vinventory.WarehouseId,
                vinventory.ProductId,
                vinventory.Stock           
        );
    END;


*/

-- Audit 

