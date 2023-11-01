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
Name            VARCHAR2(30)
);

CREATE TABLE Products (
Product_Id      NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Name            VARCHAR2(30),
Category        VARCHAR2(15)
);

CREATE TABLE Warehouse( 
Warehouse_Id    NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Name            VARCHAR2(20),
Address         VARCHAR2(50)
);

CREATE TABLE Reviews (
Review_Id       NUMBER(5)          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Product_Id      NUMBER(5)          REFERENCES Products(Product_Id),
Flag            NUMBER(1,0),
Descrption      VARCHAR2(200)
);

CREATE TABLE Inventory (
Warehouse_Id    NUMBER(5)          REFERENCES Warehouse(Warehouse_Id) ,
Product_Id      NUMBER(5)          REFERENCES Products(Product_Id),

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

