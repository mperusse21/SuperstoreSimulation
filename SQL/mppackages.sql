-- Orders
-- create exceptions for negative price/quantity
CREATE OR REPLACE PROCEDURE add_order (
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
/

-- takes an orderid and deletes all rows with the orderid. (if it has multiple products they will all be deleted)
CREATE OR REPLACE PROCEDURE delete_order (
    vorderid IN NUMBER
) IS
BEGIN
DELETE FROM Orders WHERE OrderId = vorderid;
END;
/

CREATE OR REPLACE PROCEDURE updatequantity (
vorderid IN NUMBER,
vproductid IN NUMBER,
vquantity IN NUMBER
) IS
BEGIN
    UPDATE Orders
    SET
        quantity = vquantity
    WHERE
        OrderId = vorderid AND ProductId = vproductid;
END;
/

CREATE OR REPLACE PROCEDURE updateprice (
vorderid IN NUMBER,
vproductid IN NUMBER,
vprice IN NUMBER
) IS
BEGIN
    UPDATE Orders
    SET
        Price = vprice
    WHERE
        OrderId = vorderid AND ProductId = vproductid;
END;
/

CREATE OR REPLACE PROCEDURE updatedate (
vorderid IN NUMBER,
vproductid IN NUMBER,
vorderdate IN DATE
) IS
BEGIN
    UPDATE Orders
    SET
        Date = vorderdate
    WHERE
        OrderId = vorderid AND ProductId = vproductid;
END;
/

-- Gets an order with a certain id and product (example order 1 apple)
CREATE OR REPLACE FUNCTION get_order (vorderid NUMBER, vproductid NUMBER)
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
/

-- Reviews 
-- Add exceptions for negative flag and score over 5 or less than 1
CREATE OR REPLACE PROCEDURE add_review (
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
/

-- takes an reviewid and deletes all rows with the revuewid.
CREATE OR REPLACE PROCEDURE delete_review (
    vreviewid IN NUMBER(5)
) IS
BEGIN
DELETE FROM Reviews WHERE ReviewId = vreviewid;
END;
/

CREATE OR REPLACE PROCEDURE updatescore (
vreviewid IN NUMBER,
vscore IN NUMBER
) IS
BEGIN
    UPDATE Reviews
    SET
        Score = vscore
    WHERE
        ReviewId = vreviewid;
END;
/

CREATE OR REPLACE PROCEDURE updateflag (
vreviewid IN NUMBER,
vflag IN NUMBER
) IS
BEGIN
    UPDATE Reviews
    SET
        Flag = vflag
    WHERE
        ReviewId = vreviewid;
END;
/

CREATE OR REPLACE PROCEDURE updatedescription (
vreviewid IN NUMBER,
vdescription IN NUMBER
) IS
BEGIN
    UPDATE Reviews
    SET
        Description = vdescription
    WHERE
        ReviewId = vreviewid;
END;
/

CREATE OR REPLACE FUNCTION get_review (vreviewid NUMBER)
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
/


-- Warehouses

CREATE OR REPLACE PROCEDURE add_warehouse (
    vwarehouse IN warehouse_typ 
) IS
BEGIN
INSERT INTO Warehouse (WarehouseName, Address_id)   
    VALUES (
    -- If reviewid will be generated
            vwarehouse.WarehouseName,
            vwarehouse.Address_id
    );
END;
/

CREATE OR REPLACE PROCEDURE delete_warehouse (
    vwarehouseid IN NUMBER(5)
) IS
BEGIN
DELETE FROM Warehouses WHERE WarehouseId= vwarehouseid;
END;
/

CREATE OR REPLACE PROCEDURE updatewarehousename (
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
/

CREATE OR REPLACE FUNCTION get_warehouse (vwarehouseid NUMBER)
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
/

-- Inventory
-- Make exception so stock can't be negativc

CREATE OR REPLACE PROCEDURE add_inventory (
    vinventory IN inventory_typ  
) IS
BEGIN
INSERT INTO Inventory   
    VALUES (
    -- If reviewid will be generated
            vinventory.WarehouseId,
            vinventory.ProductId,
            vinventory.Stock           
    );
END;
/

CREATE OR REPLACE PROCEDURE delete_inventory (
    vwarehouseid IN NUMBER(5),
    vproductid IN NUMBER(5)
) IS
BEGIN
DELETE FROM Inventory WHERE WarehouseId= vwarehouseid AND ProductId = vproductid;
END;
/

CREATE OR REPLACE PROCEDURE updatestock (
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
/

CREATE OR REPLACE FUNCTION get_stock (vwarehouseid NUMBER, vproductid NUMBER)
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
    
    return total_stock;
END;
/

-- Gets the stock of a product in all warehouses combined
CREATE OR REPLACE FUNCTION get_total_inventory (vproductid NUMBER)
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
/



