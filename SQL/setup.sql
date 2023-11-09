DROP TABLE Cities CASCADE CONSTRAINTS;
DROP TABLE Addresses CASCADE CONSTRAINTS;
DROP TABLE Stores CASCADE CONSTRAINTS;
DROP TABLE Products CASCADE CONSTRAINTS;
DROP TABLE Customers CASCADE CONSTRAINTS;
DROP TABLE Warehouses CASCADE CONSTRAINTS;
DROP TABLE Reviews CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;


CREATE TABLE Cities (
    CityId          NUMBER(5)       GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    City            VARCHAR2(50)    NOT NULL,
    Province        VARCHAR2(20)
);
/

CREATE TABLE Addresses (
    AddressId       NUMBER(5)        GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    Address         VARCHAR2(50)     NOT NULL,
    CityId          NUMBER(5)        REFERENCES Cities (CityId)
);
/

CREATE TABLE Stores (   
    StoreId         NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    StoreName       VARCHAR2(30)       NOT NULL
);
/

CREATE TABLE Products (
    ProductId       NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ProductName     VARCHAR2(30)       NOT NULL,
    Category        VARCHAR2(20)
);
/

CREATE TABLE Customers (
    CustomerId      NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Firstname       VARCHAR2(20),
    Lastname        VARCHAR2(20),
    Email           VARCHAR2(30),
    Addressid       NUMBER(5)          REFERENCES Addresses (AddressId)
);
/

CREATE TABLE Warehouses( 
    WarehouseId     NUMBER(5)          GENERATED ALWAYS AS IDENTITY,
    ProductId       NUMBER(5)          REFERENCES Products (ProductId),
    WarehouseName   VARCHAR2(20),
    Stock           NUMBER(10,0),
    Address_id      NUMBER(5)          REFERENCES Addresses (AddressId),
    
    CONSTRAINT warehouses_pk PRIMARY KEY (WarehouseId, ProductId)
);
/

CREATE TABLE Reviews (
    ReviewId        NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ProductId       NUMBER(5)          REFERENCES Products (ProductId),
    CustomerId      NUMBER(5)          REFERENCES Customers (CustomerId),
    Score           NUMBER(1,0),
    Flag            NUMBER(1,0),
    Description     VARCHAR2(200)
);
/

CREATE TABLE Orders (
    OrderId         NUMBER(5)          GENERATED ALWAYS AS IDENTITY,
    ProductId       NUMBER(5)          REFERENCES Products (ProductId),
    CustomerId      NUMBER(5)          REFERENCES Customers (CustomerId),
    StoreId         NUMBER(5)          REFERENCES Stores(StoreId),
    Quantity        NUMBER(5,0),
    Price           NUMBER (10,2),
    OrderDate       DATE,
    
    CONSTRAINT orders_pk PRIMARY KEY (OrderId, ProductId)
);
/

COMMIT;

INSERT INTO Customers (Firstname,Lastname,Email,Address) VALUES ('Mahsa','Sadeghi','msadeghi@dawsoncollege.qc.ca','Dawson College, Montreal, Quebec, Canada');
SELECT * FROM Customers;
INSERT INTO Stores (Store_Name) VALUES ('Marche Atwater');
SELECT * FROM Stores;
INSERT INTO Products (Product_Name,Category) VALUES ('Laptop ASUS 104S','Electronics');
SELECT * FROM Products;
INSERT INTO Warehouse (Warehouse_Name,Address) VALUES ('A','100 Rue William, Saint Laurent, Quebec, Canada'); 
SELECT * FROM Warehouse;
INSERT INTO Reviews (Product_Id,Flag,Description) VALUES (1,0,'It was affordable');
SELECT * FROM Reviews;
INSERT INTO Inventory VALUES(1,1,1000);
SELECT * FROM Inventory;
INSERT INTO Orders (Customer_Id,Store_Id,Quantity,OrderDate,Price) VALUES
(1,1,1,SYSDATE,970);
SELECT * FROM Orders;
INSERT INTO Products_Orders VALUES (1,1);
SELECT * FROM Products_Orders;

SELECT *
FROM
Customers INNER JOIN Orders
USING (customer_id)
INNER JOIN Products_orders
USING (order_id)
INNER JOIN Products
USING (product_id)
INNER JOIN Inventory
USING (product_id)
INNER JOIN Warehouse
USING (warehouse_id);


-- SQL types for tables with more than 3 columns (and products because it's important)
/*
JUST IN CASE!
CREATE OR REPLACE TYPE addresses_type AS OBJECT(
    AddressId       NUMBER(5), 
    Address         VARCHAR2(50),
    CityId          NUMBER(5)
);
/

CREATE OR REPLACE TYPE cities_type AS OBJECT(
    CityId          NUMBER(5), 
    City            VARCHAR2(50),
    Province        VARCHAR2(20)
);
/
*/
CREATE OR REPLACE TYPE reviews_typ AS OBJECT(
    ReviewId        NUMBER(5),
    ProductId       NUMBER(5),
    CustomerId      NUMBER(5),
    Score           NUMBER(1,0),
    Flag            NUMBER(1,0),
    Description     VARCHAR2(200)
);
/


CREATE OR REPLACE TYPE warehouse_typ AS OBJECT(
    WarehouseId     NUMBER(5),
    ProductId       NUMBER(5),
    WarehouseName   VARCHAR2(20),
    Stock           NUMBER(10,0),
    Address_id      NUMBER(5)
);
/


CREATE OR REPLACE TYPE customers_type AS OBJECT(
    CustomerId      NUMBER(5),
    Firstname       VARCHAR2(20),
    Lastname        VARCHAR2(20),
    Email           VARCHAR2(30),
    Addressid       NUMBER(5)  
);
/

CREATE OR REPLACE TYPE products_type AS OBJECT(
    ProductId       NUMBER(5),
    ProductName     VARCHAR2(30),
    Category        VARCHAR2(20)
);
/

CREATE OR REPLACE TYPE orders_typ AS OBJECT(
    OrderId         NUMBER(5),
    ProductId       NUMBER(5),
    CustomerId      NUMBER(5),
    StoreId         NUMBER(5),
    Quantity        NUMBER(5,0),
    Price           NUMBER (10,2),
    OrderDate       DATE
);
/






