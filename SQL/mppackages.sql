-- Orders
-- when order placed: check if any warehouse has enough quantity, add the order, update quantity
CREATE OR REPLACE PACKAGE orders_package AS
    PROCEDURE add_order(vorder IN orders_typ);
    PROCEDURE delete_order(vorderid IN NUMBER);
    FUNCTION get_order(vorderid NUMBER, vproductid NUMBER)
        RETURN orders_typ;
    FUNCTION get_times_ordered (vproductid NUMBER)
        RETURN NUMBER;
    TYPE products_id_varray IS VARRAY(100) OF NUMBER;
    TYPE order_varray IS VARRAY(100) OF orders_typ;
    -- Not sure if necessary, added for now
    FUNCTION get_all_order_products (vorderid NUMBER)
        RETURN order_varray;
    FUNCTION get_total_inventory (vproductid NUMBER)
        RETURN NUMBER;
    FUNCTION validate_order (vproductid NUMBER)
        RETURN BOOLEAN;
    ORDER_NOT_FOUND EXCEPTION;
    OUT_OF_STOCK EXCEPTION;
END orders_package;
/

CREATE OR REPLACE PACKAGE BODY orders_package AS 
PROCEDURE add_order (
    vorder IN orders_typ
) AS
    BEGIN
    -- if there is no stock in any warehouse raises an exception
    IF validate_order(vorder.productid) = false THEN
        RAISE OUT_OF_STOCK;
    END IF;
    
    INSERT INTO Orders 
        VALUES (
        -- If orderId is null one will be generated
                vorder.OrderId,
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
    
-- Gets the stock of a product in all warehouses combined (used for validation)
FUNCTION get_total_inventory (vproductid NUMBER)
    RETURN NUMBER AS
        total_stock NUMBER(10,0);
    BEGIN
        SELECT
        -- Null is the same as having no stock
            NVL(SUM(Stock), 0)
        INTO
            total_stock
        FROM
            Inventory
        WHERE
            ProductId = vproductid;
        
        return total_stock;
    END;
    
FUNCTION validate_order (vproductid NUMBER)
    RETURN BOOLEAN AS
       total_stock NUMBER(10, 0);
    BEGIN
        total_stock := get_total_inventory(vproductid);
        
        IF total_stock = 0 THEN
            return false;
        ELSE
            return true;
        END IF;
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
    PROCEDURE update_reviews(vreview_id NUMBER, vscore NUMBER, vflag VARCHAR2, vdescription VARCHAR2);
    FUNCTION get_review (vreviewid NUMBER)
        RETURN reviews_typ;
    FUNCTION get_average_score (vproductid NUMBER)
        RETURN NUMBER;
    TYPE customer_id_varray IS VARRAY(100) OF NUMBER;
    FUNCTION get_flagged_customers 
        RETURN customer_id_varray;
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
    
-- Takes necessary information and updates a review
PROCEDURE update_reviews(vreview_id NUMBER, vscore NUMBER, vflag VARCHAR2, vdescription VARCHAR2) IS
    BEGIN
        UPDATE Reviews SET Score = vscore WHERE ReviewId = vreview_id;
        UPDATE Reviews SET Flag = vflag WHERE ReviewId = vreview_id;
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
    RETURN customer_id_varray AS
        flagged_customers customer_id_varray;
    BEGIN
        SELECT
            CustomerId
        BULK COLLECT INTO
            flagged_customers
        FROM
            Customers INNER JOIN Reviews
            USING (CustomerId)
        GROUP BY
            CustomerId
        HAVING
            SUM(Flag) > 1;
        RETURN flagged_customers;
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
    PROCEDURE add_inventory (vinventory IN inventory_typ);
    PROCEDURE updatestock(vwarehouseid IN NUMBER, vproductid IN NUMBER, vstock IN NUMBER);
    FUNCTION get_stock (vwarehouseid NUMBER, vproductid NUMBER)
        RETURN NUMBER;
    INVENTORY_NOT_FOUND EXCEPTION;
END inventory_package;
/

CREATE OR REPLACE PACKAGE BODY inventory_package AS 
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

DECLARE
    warehouse warehouse_typ;
BEGIN
    -- This exception doesn't work dbms_output.put_line(inventory_package.get_stock(1000,9));
    -- dbms_output.put_line(inventory_package.get_total_inventory(100));
    --inventory_package.updatestock(1003230,1,214492);
    -- dbms_output.put_line(orders_package.get_total_inventory(100));
   warehouse := warehouses_package.get_warehouse(100);
/*EXCEPTION
     WHEN ORDER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order with this id found');
     WHEN REVIEW_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order with this id found');     
    WHEN WAREHOUSE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order with this id found');     
    WHEN INVENTORY_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order with this id found');
END;


 Got rid of all these, might re-add
    EXCEPTION
        WHEN ORDER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order with this id found');
        
        
CREATE OR REPLACE PACKAGE tests AS
    TYPE orders_id_varray IS VARRAY(100) OF NUMBER;
    FUNCTION display_orders (vcustomerid NUMBER)
        RETURN orders_id_varray;
END tests;
/

CREATE OR REPLACE PACKAGE BODY orders_package AS 
PROCEDURE display_orders (vcustomerid IN NUMBER) IS
    BEGIN
        SELECT
            OrderID
        FROM
            Orders
        WHERE
            CustomerId = vcustomerid;
    END;
END tests;
    
*/
  

-- Audit 

