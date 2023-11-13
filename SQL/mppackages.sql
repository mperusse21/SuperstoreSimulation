-- Orders

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
DELETE FROM Reviews WHERE ReviewId = vorderid;
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




