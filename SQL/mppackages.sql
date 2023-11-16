-- Orders
-- create exceptions for negative price/quantity

CREATE OR REPLACE PACKAGE orders_package AS
    PROCEDURE add_order(vorder IN orders_typ);
    PROCEDURE delete_order(vorderid IN NUMBER);
    FUNCTION get_order(vorderid NUMBER, vproductid NUMBER)
        RETURN orders_typ;
    FUNCTION get_times_ordered (vproductid NUMBER)
        RETURN NUMBER;
END orders_package;
/

CREATE OR REPLACE PACKAGE BODY orders_package AS 
PROCEDURE add_order (
    vorder IN orders_typ
) IS
    BEGIN
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
        
        return times_ordered;
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
-- Add exceptions for negative flag and score over 5 or less than 1

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
END reviews_package;
/

CREATE OR REPLACE PACKAGE BODY reviews_package AS 
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
    END delete_review;
PROCEDURE update_reviews(vreview_id NUMBER, vscore NUMBER, vflag VARCHAR2, vdescription VARCHAR2) IS
    BEGIN
        UPDATE Reviews SET Score = vscore WHERE ReviewId = vreview_id;
        UPDATE Reviews SET Flag = vflag WHERE ReviewId = vreview_id;
        UPDATE Reviews SET Description = vdescription WHERE ReviewId = vreview_id;
    END; 
    
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
        
        return average_score;
    END;
    
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
END warehouses_package;
/

CREATE OR REPLACE PACKAGE BODY warehouses_package AS 
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

PROCEDURE delete_warehouse (
    vwarehouseid IN NUMBER
) IS
    BEGIN
        DELETE FROM Warehouses WHERE WarehouseId= vwarehouseid;
    END;

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
    END;
    

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
-- Make exception so stock can't be negativc

CREATE OR REPLACE PACKAGE inventory_package AS
    PROCEDURE add_inventory (vinventory IN inventory_typ);
    PROCEDURE updatestock(vwarehouseid IN NUMBER, vproductid IN NUMBER, vstock IN NUMBER);
    FUNCTION get_stock (vwarehouseid NUMBER, vproductid NUMBER)
        RETURN NUMBER;
    FUNCTION get_total_inventory (vproductid NUMBER)
        RETURN NUMBER;
END inventory_package;
/

CREATE OR REPLACE PACKAGE BODY inventory_package AS 
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
    END;
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
        
        return vstock;
    END;
-- Gets the stock of a product in all warehouses combined
FUNCTION get_total_inventory (vproductid NUMBER)
    RETURN NUMBER AS
        total_stock NUMBER(10,0);
    BEGIN
        SELECT
            SUM(Stock)
        INTO
            total_stock
        FROM
            Inventory
        WHERE
            ProductId = vproductid;
        
        return total_stock;
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

DROP TRIGGER InventoryChange;



