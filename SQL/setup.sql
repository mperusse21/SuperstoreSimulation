DROP TABLE Provinces CASCADE CONSTRAINTS;
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
    City            VARCHAR2(50),
    Province        VARCHAR2(20)    
);
/

CREATE TABLE Addresses (
    AddressId       NUMBER(5)        GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    Address         VARCHAR2(50),
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

-- Insert statements 
-- Cities
INSERT INTO Cities (City, Province) VALUES ('Montreal', 'Quebec');
INSERT INTO Cities (City, Province) VALUES ('Toronto', 'Ontatio');
INSERT INTO Cities (City, Province) VALUES ('Calgary', 'Alberta');
INSERT INTO Cities (City, Province) VALUES ('Laval', 'Quebec');
INSERT INTO Cities (City, Province) VALUES ('Brossard', 'Quebec');
-- Warehouse Cities
INSERT INTO Cities (City, Province) VALUES ('Saint Laurent', 'Quebec');
INSERT INTO Cities (City, Province) VALUES ('Quebec City', 'Quebec');
INSERT INTO Cities (City, Province) VALUES ('Ottawa', 'Ontario');
INSERT INTO Cities (Province) VALUES ('Alberta');



-- Addresses
INSERT INTO Addresses (Address, CityId) VALUES ('87 boul saint laurent', 1);
INSERT INTO Addresses (Address, CityId) VALUES ('090 boul saint laurent', 1);
INSERT INTO Addresses (Address, CityId) VALUES ('100 boul saint laurent', 1);
INSERT INTO Addresses (Address, CityId) VALUES ('100 atwater street', 2);
INSERT INTO Addresses (Address, CityId) VALUES ('dawson college', 1);
INSERT INTO Addresses (Address, CityId) VALUES ('100 Young street', 2);
INSERT INTO Addresses (Address, CityId) VALUES ('104 gill street', 2);
INSERT INTO Addresses (Address, CityId) VALUES ('105 Young street', 2);
INSERT INTO Addresses (Address, CityId) VALUES ('22222 happy street', 4);
INSERT INTO Addresses (Address, CityId) VALUES ('76 boul decalthon', 4);
-- For customers with no address and only city
INSERT INTO Addresses (CityId) VALUES (3);
INSERT INTO Addresses (CityId) VALUES (5);
-- Warehouse Addresses
INSERT INTO Addresses (Address, CityId) VALUES ('100 rue William', 6);
-- This is wrong but the address confused me
-- INSERT INTO Addresses (Address, CityId) VALUES ('304 Rue François-Perrault, Villera Saint-Michel', 1);
INSERT INTO Addresses (Address, CityId) VALUES ('86700 Weston Rd', 2);
INSERT INTO Addresses (Address, CityId) VALUES ('170 Sideroad', 7);
INSERT INTO Addresses (Address, CityId) VALUES ('1231 Trudea road', 8);
INSERT INTO Addresses (Address, CityId) VALUES ('16 Whitlock Rd', 9);

-- Stores (stores with same name only differentiated by StoreId) NOT SURE IF CORRECT!!!!
INSERT INTO Stores (StoreName) VALUES ('dawson store');
INSERT INTO Stores (StoreName) VALUES ('dealer montreal');
INSERT INTO Stores (StoreName) VALUES ('Dealer one');
INSERT INTO Stores (StoreName) VALUES ('marche adonis');
INSERT INTO Stores (StoreName) VALUES ('movie start');
INSERT INTO Stores (StoreName) VALUES ('movie store');
INSERT INTO Stores (StoreName) VALUES ('star store');
-- Quebec
INSERT INTO Stores (StoreName) VALUES ('store magic');
-- Toronto
INSERT INTO Stores (StoreName) VALUES ('store magic');
INSERT INTO Stores (StoreName) VALUES ('super rue champlain');
-- Quebec
INSERT INTO Stores (StoreName) VALUES ('toy r us');
-- Toronto
INSERT INTO Stores (StoreName) VALUES ('toy r us');
-- Quebec
INSERT INTO Stores (StoreName) VALUES ('marche atwater');
-- Calgary
INSERT INTO Stores (StoreName) VALUES ('marche atwater');

-- Products

INSERT INTO Products (ProductName, Category) VALUES ('apple', 'Grocery');
INSERT INTO Products (ProductName, Category) VALUES ('Barbie Movie', 'DVD');
INSERT INTO Products (ProductName, Category) VALUES ('SIMS CD', 'Video Games');
INSERT INTO Products (ProductName, Category) VALUES ('paper towel', 'Beauty');
INSERT INTO Products (ProductName, Category) VALUES ('Truck 500c ', 'Vehicle');
INSERT INTO Products (ProductName, Category) VALUES ('orange', 'Grocery');
INSERT INTO Products (ProductName, Category) VALUES ('plum', 'Grocery');
INSERT INTO Products (ProductName, Category) VALUES ('BMW i6', 'Cars');
INSERT INTO Products (ProductName, Category) VALUES ('laptop ASUS 104S', 'electronics');
INSERT INTO Products (ProductName, Category) VALUES ('BMW iX Lego', 'Toys');
INSERT INTO Products (ProductName, Category) VALUES ('Lamborghini Lego', 'Toys');
INSERT INTO Products (ProductName, Category) VALUES ('L''Oreal Normal Hair', 'Health');
INSERT INTO Products (ProductName, Category) VALUES ('chicken', 'Grocery');
INSERT INTO Products (ProductName, Category) VALUES ('PS5', 'electronics');
INSERT INTO Products (ProductName, Category) VALUES ('pasta', 'Grocery');


-- Customers
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Alex', 'Brown', 'alex@gmail.com', 2);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Amanda', 'Harry', 'am.harry@yahioo.com', 3);
INSERT INTO Customers (Firstname, Lastname, Email) VALUES ('Ari', 'Brown', 'b.a@gmail.com');
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Daneil', 'Hanne', 'daneil@yahoo.com', 4);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Jack', 'Jonhson', 'johnson.a@gmail.com', 11);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('John', 'Boura', 'bdoura@gmail.com', 6);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('John', 'Belle', 'abcd@yahoo.com', 8);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Mahsa', 'Sadeghi', 'msadeghi@dawsoncollege.qc.ca', 5);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Mahsa', 'Sadeghi', 'ms@gmail.com', 7);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Martin', 'Alexandre', 'marting@yahoo.com', 12);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Martin', 'Li', 'm.li@gmail.com', 1);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Noah', 'Garcia', 'g.noah@yahoo.com', 9);
INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES ('Olivia', 'Smith', 'smith@hotmail.com', 10);

-- Warehouses (Doesn't work with generated identity, have to change)

INSERT INTO Warehouses (ProductId, WarehouseName, Stock, Address_id) 
    VALUES (9, 'Warehouse A', 1000, 13);
INSERT INTO Warehouses (WarehouseId, ProductId, WarehouseName, Stock, Address_id) 
    VALUES (1, 10, 'Warehouse A', 10, 13); 
    

COMMIT;

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


COMMIT;




