-- Warehouses
-- Package for functions and procedures related to the warehouse table
CREATE OR REPLACE PACKAGE warehouses_package AS
    PROCEDURE delete_warehouse (vwarehouseid IN NUMBER);
    PROCEDURE updatewarehousename(vwarehouseid NUMBER, vwarehousename IN VARCHAR2);
    FUNCTION get_warehouse (vwarehouseid NUMBER)
        RETURN warehouse_typ;
    WAREHOUSE_NOT_FOUND EXCEPTION;
END warehouses_package;
/

CREATE OR REPLACE PACKAGE BODY warehouses_package AS 
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

-- Gets a warehouse with a given id and returns an object of the warehouse_typ
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

-- Inventory
-- Package containing procedures and functions related to the inventory table.
CREATE OR REPLACE PACKAGE inventory_package AS
    PROCEDURE update_stock(vinventoryid IN NUMBER, vstock IN NUMBER);
    FUNCTION get_total_stock (vproductid NUMBER)
        RETURN NUMBER;
    FUNCTION get_all_inventory 
        RETURN SYS_REFCURSOR;
    INVENTORY_NOT_FOUND EXCEPTION;
END inventory_package;
/

CREATE OR REPLACE PACKAGE BODY inventory_package AS 
-- Updates a warehouse's stock of a product (using it's inventory id)
PROCEDURE update_stock (
    vinventoryid IN NUMBER,
    vstock IN NUMBER
) IS
    BEGIN
        UPDATE Inventory
        SET
            Stock = vstock
        WHERE
            InventoryId = vinventoryid;
        
        IF SQL%NOTFOUND THEN
            RAISE INVENTORY_NOT_FOUND;
        END IF;
    END;
    
-- Returns the total stock of a specific product across all warehouses
FUNCTION get_total_stock (vproductid NUMBER)
    RETURN NUMBER AS
        total_stock NUMBER;
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
        RETURN total_stock;
    END;
    
-- Returns a cursor containing the every row in the inventory table.
FUNCTION get_all_inventory 
    RETURN SYS_REFCURSOR AS
        all_inventory SYS_REFCURSOR;
    BEGIN
        OPEN all_inventory FOR 
        SELECT 
            *
        FROM
            Inventory
        ORDER BY
            InventoryId ASC;
        RETURN all_inventory;
    END;
END inventory_package;
/

-- Orders
-- Package for all functions and procedures related to the orders table.
-- Includes validation when adding an order.
CREATE OR REPLACE PACKAGE orders_package AS
    PROCEDURE add_order(vorder IN orders_typ);
    PROCEDURE delete_order(vorderid IN NUMBER);
    FUNCTION get_order (vorderid NUMBER, vproductid NUMBER)
        RETURN orders_typ;
    FUNCTION validate_order (vproductid NUMBER, quantity NUMBER)
        RETURN VARCHAR2;
    FUNCTION get_customer_orders (vcustomerid NUMBER)
        RETURN SYS_REFCURSOR;
    FUNCTION get_all_orders 
        RETURN SYS_REFCURSOR;
    ORDER_NOT_FOUND EXCEPTION;
    OUT_OF_STOCK EXCEPTION;
END orders_package;
/

CREATE OR REPLACE PACKAGE BODY orders_package AS 
-- Private function that gets and returns the max stock in any warehouse,
-- used for public validate order function
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

-- Private function for updating stock after an order is placed
PROCEDURE update_stock_after_order (vproductid IN NUMBER, vquantity IN NUMBER)
    AS
            vinventoryid NUMBER(5);
            vstock NUMBER;
            newStock NUMBER;
    BEGIN
        -- Gets the inventory id with the most stock of a specific product
        SELECT
            InventoryId,
            Stock
        INTO
            vinventoryid,
            vstock
        FROM
            Inventory
        WHERE
            ProductId = vproductid         
        ORDER BY
            Stock DESC
        FETCH FIRST ROW ONLY;
        
        -- Calculates the new stock by subtracting the order quantity from current stock
        newStock := vstock - vquantity;
        
        -- Calling the inventory package Update stock procedure to set the new stock
        inventory_package.update_stock(vinventoryid, newStock);
    END;
    
-- Was originally a boolean but couldn't get the boolean type to work in JDBC
-- Returns true or false depending on if any warehouse has enough stock to fulfull an order
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

-- Takes an order object and adds it to the database if it passes validation.
PROCEDURE add_order (
    vorder IN orders_typ
) AS
    vorder_id NUMBER(5) := vorder.OrderId;
    BEGIN
    -- if there is not enough stock in any warehouse raises an exception (validate_order returns 'false')
    IF validate_order(vorder.ProductId, vorder.Quantity) = 'false' THEN
        RAISE OUT_OF_STOCK;
    END IF;
    
    -- Handles when JDBC id is 0 (considered null and means an id will be generated)
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
        
        -- After successful insert calls the private procedure to update the stock reflecting the order quantity
        update_stock_after_order(vorder.ProductId, vorder.Quantity);
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
    
-- Gets an order with a certain id and product (example order 1 apple).
-- Then returns an order object with all relevant information.
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

-- Returns a cursor containing all orders by a specific customer 
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
            CustomerId = vcustomerid
        ORDER BY
            OrderId ASC; 
        RETURN customer_orders;
    END;

-- Returns a cursor containing all rows in the orders table.
FUNCTION get_all_orders 
    RETURN SYS_REFCURSOR AS
        all_orders SYS_REFCURSOR;
    BEGIN
        OPEN all_orders FOR 
        SELECT 
            *
        FROM
            Orders
        ORDER BY
            OrderId ASC;
        RETURN all_orders;
    END;
END orders_package;
/

-- Reviews 
-- Package for functions and procedures related to the Reviews table.
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
    FUNCTION get_all_reviews 
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
    
-- takes a reviewid and deletes all rows with the reviewid.
PROCEDURE delete_review (
        vreviewid IN NUMBER
    ) IS
    BEGIN
        DELETE FROM Reviews WHERE ReviewId = vreviewid;
        IF SQL%NOTFOUND THEN
            RAISE REVIEW_NOT_FOUND;
        END IF;
    END;
    
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
    
-- Gets and returns a review object using a specified id
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
    
-- Returns a cursor with all customers whose reviews have been flagged more than once
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
            SUM(Flag) > 1
        ORDER BY 
            CustomerId ASC; 
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
            Flag > 0
        ORDER BY
            ReviewId ASC; 
        RETURN flagged_reviews;
    END;
    
FUNCTION get_all_reviews 
        RETURN SYS_REFCURSOR AS
        all_reviews SYS_REFCURSOR;
    BEGIN
        OPEN all_reviews FOR 
        SELECT 
            *
        FROM
            Reviews
        ORDER BY
            ReviewId ASC; 
        RETURN all_reviews;
    END;
    
END reviews_package;
/

-- Triggers

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

CREATE OR REPLACE TRIGGER InventoryChange
AFTER INSERT OR UPDATE OR DELETE ON Inventory
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.InventoryId, 'INSERT', 'INVENTORY', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.InventoryId, 'DELETE', 'INVENTORY', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.InventoryId, 'UPDATE', 'INVENTORY', SYSDATE);
    END IF;
END;
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

/*-- Gets and returns the stock (number) of a product in a warehouse
FUNCTION get_stock (vinventoryid NUMBER)
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
            InventoryId = vinventoryid;
        
        IF SQL%NOTFOUND THEN
            RAISE INVENTORY_NOT_FOUND;
        END IF;
        
        return vstock;
    END;*/