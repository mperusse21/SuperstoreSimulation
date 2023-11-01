DROP TABLE Customers CASCADE CONSTRAINTS;
DROP TABLE Stores CASCADE CONSTRAINTS;
DROP TABLE Products CASCADE CONSTRAINTS;
DROP TABLE Warehouse CASCADE CONSTRAINTS;
DROP TABLE Reviews CASCADE CONSTRAINTS;
DROP TABLE Inventory CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE Products_Orders CASCADE CONSTRAINTS;


CREATE TABLE Customers (
Customer_Id     NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Firstname       VARCHAR2(20),
Lastname        VARCHAR2(20),
Email           VARCHAR2(30),
Address         VARCHAR2(50)
);

CREATE TABLE Stores (   
Store_Id        NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Store_Name      VARCHAR2(30)
);

CREATE TABLE Products (
Product_Id      NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Product_Name    VARCHAR2(30),
Category        VARCHAR2(15)
);

CREATE TABLE Warehouse( 
Warehouse_Id    NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Warehouse_Name  VARCHAR2(20),
Address         VARCHAR2(50)
);

CREATE TABLE Reviews (
Review_Id       NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Product_Id      NUMBER(5)          REFERENCES Products(Product_Id),
Flag            NUMBER(1,0),
Description      VARCHAR2(200)
);

CREATE TABLE Inventory (
Warehouse_Id    NUMBER(5)          REFERENCES Warehouse(Warehouse_Id) ,
Product_Id      NUMBER(5)          REFERENCES Products(Product_Id),
Stock           NUMBER(10,0),

CONSTRAINT inventory_pk PRIMARY KEY (Warehouse_Id, Product_Id)
);

CREATE TABLE Orders (
Order_Id        NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Customer_Id     NUMBER(5)          REFERENCES Customers(customer_id),
Store_Id        NUMBER(5)          REFERENCES Stores(Store_Id),
Quantity        NUMBER(2,0),
OrderDate       DATE,
Price           NUMBER (10,2)
);

CREATE TABLE Products_Orders (
Order_Id        NUMBER(5)          REFERENCES Orders(Order_Id) ,
Product_Id      NUMBER(5)          REFERENCES Products(Product_Id),

CONSTRAINT ProductsOrders_pk PRIMARY KEY (Order_Id, Product_Id)
);

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

-- Mohammad's work

-- Mitchell's work

CREATE OR REPLACE TYPE stores_typ AS OBJECT(
    Store_Id  NUMBER(5),
    Store_Name VARCHAR2(30)
);
/

CREATE OR REPLACE TYPE reviews_typ AS OBJECT(
    Review_Id       NUMBER(5),
    Product_Id      NUMBER(5),
    Flag            NUMBER(1,0),
    Description      VARCHAR2(200)
);
/

CREATE OR REPLACE TYPE warehouse_typ AS OBJECT(
    Warehouse_Id    NUMBER(5),
    Warehouse_Name  VARCHAR2(20),
    Address         VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE inventory_typ AS OBJECT(
    Warehouse_Id    NUMBER(5),
    Product_Id      NUMBER(5),
    Stock           NUMBER(10,0)
);
/




