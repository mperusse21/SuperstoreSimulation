DROP TABLE Provinces CASCADE CONSTRAINTS;
DROP TABLE Cities CASCADE CONSTRAINTS;
DROP TABLE Addresses CASCADE CONSTRAINTS;
DROP TABLE Stores CASCADE CONSTRAINTS;
DROP TABLE Products CASCADE CONSTRAINTS;
DROP TABLE Customers CASCADE CONSTRAINTS;
DROP TABLE Warehouses CASCADE CONSTRAINTS;
DROP TABLE Reviews CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;

CREATE TABLE Provinces (
    ProvinceId      NUMBER(5)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Province        VARCHAR2(20)   NOT NULL
);
/

CREATE TABLE Cities (
    CityId          NUMBER(5)       GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    City            VARCHAR2(50)    NOT NULL,
    ProvinceId      NUMBER(5)       REFERENCES Provinces (ProvinceId)
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

INSERT INTO Provinces (Province) VALUES ('Quebec');
INSERT INTO Provinces (Province) VALUES ('Ontario');
INSERT INTO Provinces (Province) VALUES ('Alberta');

INSERT INTO Cities (City, ProvinceId) VALUES ('Montreal', '1');
INSERT INTO Cities (City, ProvinceId) VALUES ('Toronto', '2');
INSERT INTO Cities (City, ProvinceId) VALUES ('Calgary', '3');
INSERT INTO Cities (City, ProvinceId) VALUES ('Laval', '1');
INSERt INTO Cities (City, ProvinceId) VALUES ('Brossard', 1);

-- SQL types for tables with more than 3 columns (and products because it's important)
/*
JUST IN CASE!
CREATE OR REPLACE TYPE addresses_typ AS OBJECT(
    AddressId       NUMBER(5), 
    Address         VARCHAR2(50),
    CityId          NUMBER(5)
);
/

CREATE OR REPLACE TYPE cities_typ AS OBJECT(
    CityId          NUMBER(5), 
    City            VARCHAR2(50),
    ProvinceId      NUMBER(5)
);
/

CREATE OR REPLACE TYPE provinces_typ AS OBJECT(
    ProvinceId      NUMBER(5),
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






