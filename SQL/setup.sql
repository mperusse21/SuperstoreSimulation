-- This file creates all tables and relationships of our superstore database, inserts all sample datas and creates all types

--Creating tables:

CREATE TABLE Cities (
    CityId          NUMBER(5)       GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    City            VARCHAR2(50),
    Province        VARCHAR2(20)    
);
/

CREATE TABLE Addresses (
    AddressId       NUMBER(5)        GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    Address         VARCHAR2(50),
    CityId          NUMBER(5)        REFERENCES Cities (CityId) NOT NULL
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
    Category        VARCHAR2(20)	   NOT NULL
);
/

CREATE TABLE Customers (
    CustomerId      NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Firstname       VARCHAR2(20) NOT NULL,
    Lastname        VARCHAR2(20) NOT NULL,
    Email           VARCHAR2(30) NOT NULL,
    Addressid       NUMBER(5)          REFERENCES Addresses (AddressId)
);
/

CREATE TABLE Warehouses( 
    WarehouseId     NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    WarehouseName   VARCHAR2(20) NOT NULL,
    Addressid      NUMBER(5)          REFERENCES Addresses (AddressId) NOT NULL
);
/

CREATE TABLE Inventory (
    InventoryId     NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    WarehouseId     NUMBER(5)          REFERENCES Warehouses (WarehouseId) NOT NULL,
    ProductId       NUMBER(5)          REFERENCES Products (ProductId) NOT NULL,
    Stock           NUMBER(10,0) CHECK(Stock >= 0) NOT NULL
);
/

CREATE TABLE Reviews (
    ReviewId        NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ProductId       NUMBER(5)          REFERENCES Products (ProductId) NOT NULL,
    CustomerId      NUMBER(5)          REFERENCES Customers (CustomerId) NOT NULL,
    Score           NUMBER(1,0) CHECK(Score > 0 AND Score < 6),
    Flag            NUMBER(1,0) CHECK(Flag >= 0),
    Description     VARCHAR2(200)
);
/

CREATE TABLE Orders (
    OrderId         NUMBER(5)          GENERATED BY DEFAULT ON NULL AS IDENTITY,
    ProductId       NUMBER(5)          REFERENCES Products (ProductId) NOT NULL,
    CustomerId      NUMBER(5)          REFERENCES Customers (CustomerId) NOT NULL,
    StoreId         NUMBER(5)          REFERENCES Stores(StoreId) NOT NULL,
    Quantity        NUMBER(5,0) CHECK(Quantity > 0) NOT NULL,
    Price           NUMBER (10,2) CHECK(Price >= 0) NOT NULL,
    OrderDate       DATE,
    
    CONSTRAINT orders_pk PRIMARY KEY (OrderId, ProductId)
);
/

CREATE TABLE AuditTable (

    AuditId         NUMBER(10)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ChangedId       NUMBER(5),
    Action          CHAR(6)             CHECK (Action IN ('INSERT', 'UPDATE', 'DELETE')),
    TableChanged    VARCHAR2(10)        CHECK (TableChanged IN ('PROVINCES', 'ADDRESSES', 'PRODUCTS', 'CUSTOMERS', 'WAREHOUSES', 'INVENTORY', 'REVIEWS', 'ORDERS')),
    DateModified    DATE

);
/

-- Insert statements for sample datas:

-- Cities
INSERT INTO Cities (City, Province) VALUES ('Montreal', 'Quebec');
INSERT INTO Cities (City, Province) VALUES ('Toronto', 'Ontario');
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
INSERT INTO Addresses (Address, CityId) VALUES ('304 Rue Francois-Perrault', 1);
INSERT INTO Addresses (Address, CityId) VALUES ('86700 Weston Rd', 2);
INSERT INTO Addresses (Address, CityId) VALUES ('170 Sideroad', 7);
INSERT INTO Addresses (Address, CityId) VALUES ('1231 Trudea road', 8);
INSERT INTO Addresses (Address, CityId) VALUES ('16 Whitlock Rd', 9);

-- Stores 
INSERT INTO Stores (StoreName) VALUES ('dawson store');
INSERT INTO Stores (StoreName) VALUES ('dealer montreal');
INSERT INTO Stores (StoreName) VALUES ('Dealer one');
INSERT INTO Stores (StoreName) VALUES ('marche adonis');
INSERT INTO Stores (StoreName) VALUES ('movie start');
INSERT INTO Stores (StoreName) VALUES ('movie store');
INSERT INTO Stores (StoreName) VALUES ('star store');
INSERT INTO Stores (StoreName) VALUES ('store magic');
INSERT INTO Stores (StoreName) VALUES ('super rue champlain');
INSERT INTO Stores (StoreName) VALUES ('toy r us');
INSERT INTO Stores (StoreName) VALUES ('marche atwater');
INSERT INTO Stores (StoreName) VALUES ('JavaRestaurant');

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
-- Products with 0 orders 
INSERT INTO Products (ProductName, Category) VALUES ('tomato', 'Grocery');
INSERT INTO Products (ProductName, Category) VALUES ('Train X745', 'Vehicle');
INSERT INTO Products (ProductName, Category) VALUES ('Cake', 'Food');
INSERT INTO Products (ProductName, Category) VALUES ('Pizza', 'Food');


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

-- Warehouses 

INSERT INTO Warehouses (WarehouseName, AddressId) 
    VALUES ('Warehouse A', 13);
INSERT INTO Warehouses (WarehouseName, AddressId) 
    VALUES ('Warehouse B', 14);
INSERT INTO Warehouses (WarehouseName, AddressId) 
    VALUES ('Warehouse C', 15);
INSERT INTO Warehouses (WarehouseName, AddressId) 
    VALUES ('Warehouse D', 16);
INSERT INTO Warehouses (WarehouseName, AddressId) 
    VALUES ('Warehouse E', 17);
INSERT INTO Warehouses (WarehouseName, AddressId) 
    VALUES ('Warehouse F', 18);
    
-- Inventory

INSERT INTO Inventory (WarehouseId, ProductId, Stock) 
    VALUES (1, 9, 1000);
INSERT INTO Inventory (WarehouseId, ProductId, Stock) 
    VALUES (1, 10, 10);
INSERT INTO Inventory (WarehouseId, ProductId, Stock) 
VALUES (1, 8, 6);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (1, 15, 2132);
INSERT INTO Inventory (WarehouseId, ProductId, Stock) 
VALUES (1, 16, 352222);
INSERT INTO Inventory (WarehouseId, ProductId, Stock) 
VALUES (2, 1, 24980);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (2, 4, 39484);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (3, 3, 103);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (3, 7, 43242);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (4, 6, 43242);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (4, 7, 6579);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (4, 14, 123);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (5, 2, 40);
INSERT INTO Inventory (WarehouseId, ProductId, Stock) 
VALUES (5, 5, 1000);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (5, 11, 98765);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (5, 17, 4543);
INSERT INTO Inventory (WarehouseId, ProductId, Stock)  
VALUES (6, 12, 450);
INSERT INTO Inventory (WarehouseId, ProductId, Stock) 
    VALUES (6, 4, 3532);
INSERT INTO Inventory (WarehouseId, ProductId, Stock) 
    VALUES (6, 13, 43523);


-- Reviews

INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (9, 8, 4, 0, 'it was affordable.');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (1, 1, 3, 0, 'quality was not good');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (3, 10, 2, 1, NULL);
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (6, 4, 5, 0, 'highly recommend');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (2, 1, 1, 0, NULL);    
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (12, 10, 1, 0, 'did not worth the price');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (10, 8, 1, 0, 'missing some parts');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (8, 6, 5, 1, 'trash');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (5, 3, 2, NULL, NULL);
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (4, 2, 5, NULL, NULL);
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (7, 5, 4, NULL, NULL);
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (12, 10, 3, NULL, NULL);
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (11, 8, 1, 0, 'missing some parts');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (7, 8, 4, NULL, NULL);
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (11, 9, 1, 0, 'great product');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (8, 7, 5, 1, 'bad quality.');    
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (3, 1, 1, 0, 'it was affordable.');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (2, 1, 4, 0, 'it was affordable.');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (13, 11, 4, NULL, 'it was affordable.');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (15, 13, 5, NULL, 'it was affordable.');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (10, 8, 1, 2, 'worse car i have droven!');
INSERT INTO Reviews (ProductId, CustomerId, Score, Flag, Description) 
    VALUES (15, 13, 4, NULL, 'it was affordable.');

-- Orders

INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate)
    VALUES (1, 1, 11, 2, 10.00, '2023-10-23');
-- same order
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (2, 1, 6, 1, 30.00, '2023-10-23');
INSERT INTO Orders VALUES (2, 3, 1, 6, 1, 16.00, '2023-10-23');
--
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (2, 1, 10, 1, 45.00, '2023-10-02');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (4, 2, 5, 3, 50.00, NULL);
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (5, 3, 2, 1, 856600.00, NULL);
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (6, 4, 8, 1, 2.00, '2023-10-23');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (7, 5, 11, 6, 10.00, '2020-05-06');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (8, 6, 3, 1, 50000.00, '2023-10-10');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (8, 7, 3, 1, 50000.00, '2023-08-10');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (9, 8, 4, 1, 970.00, '2023-04-21');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (10, 8, 10, 1, 40.00, '2023-10-11');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (11, 8, 10, 1, 40.00, '2010-10-11');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (7, 8, 11, 7, 10.00, '2022-05-06');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (11, 9, 10, 2, 80.00, '2023-10-07');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (10, 8, 10, 1, 38.00, '2022-10-11');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (3, 10, 1, 3, 50.00, '2023-10-01');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (12, 10, 9, 1, 10.00, '2023-10-10');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (12, 10, 9, 3, 30.00, '2019-09-12');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (13, 11, 4, 1, 9.50, '2019-04-03');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (14, 12, 7, 1, 200.00, '2020-01-20');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (15, 13, 11, 1, 13.50, '2021-12-29');
INSERT INTO Orders (ProductId, CustomerId, StoreId, Quantity, Price, OrderDate) 
    VALUES (15, 13, 8, 1, 15.00, '2021-12-29');


-- Create types for the necessary tables:

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
    WarehouseName   VARCHAR2(20),
    AddressId      NUMBER(5)
);
/

CREATE OR REPLACE TYPE inventory_typ AS OBJECT(
    InventoryId     NUMBER(5),
    WarehouseId     NUMBER(5),
    ProductId       NUMBER(5),
    Stock           NUMBER(10,0)
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




