--Cities

CREATE OR REPLACE PROCEDURE add_cities(city_name VARCHAR2, province_name VARCHAR2) IS 

BEGIN

INSERT INTO Cities (City, Province) VALUES (city_name, province_name);

END add_cities;
/

CREATE OR REPLACE PROCEDURE remove_cities(city_id NUMBER) IS

BEGIN

DELETE FROM Cities WHERE CityId = city_id;

END remove_cities;
/

--Addresses

CREATE OR REPLACE PROCEDURE add_addresses(address_name VARCHAR2, city_id NUMBER) IS

BEGIN 

INSERT INTO Addresses (Address, CityId) VALUES (address_name, city_id);

END add_addresses;
/

CREATE OR REPLACE PROCEDURE remove_addresses(address_id NUMBER) IS

BEGIN

DELETE FROM Addresses WHERE AddressId = address_id;

END remove_addresses;
/

--Stores

CREATE OR REPLACE PROCEDURE add_stores(store_name VARCHAR2) IS

BEGIN

INSERT INTO Stores (StoreName) VALUES (store_name);

END add_stores;
/

CREATE OR REPLACE PROCEDURE remove_stores(store_id NUMBER) IS

BEGIN

DELETE FROM Stores WHERE StoreId = store_id;

END remove_stores;
/

--Products

CREATE OR REPLACE PROCEDURE add_products(product_name VARCHAR2, category_name VARCHAR2) IS 

BEGIN

INSERT INTO Products (ProductName, Category) VALUES (product_name, category_name);

END add_products;
/

CREATE OR REPLACE PROCEDURE remove_products(product_id NUMBER) IS 

BEGIN

DELETE FROM Products WHERE ProductId = product_id;

END remove_products;
/

--Customers

CREATE OR REPLACE PROCEDURE add_customers(first_name VARCHAR2, last_name VARCHAR2,
customer_email VARCHAR2, address_id NUMBER) IS 

BEGIN

INSERT INTO Customers (Firstname, Lastname, Email, AddressId) VALUES 
(first_name, last_name, customer_email, address_id);

END add_customers;
/

CREATE OR REPLACE PROCEDURE remove_customers(customer_id NUMBER) IS 

BEGIN

DELETE FROM Customers WHERE CustomerId = customer_id;

END remove_customers;
/


