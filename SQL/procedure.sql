--Cities

CREATE OR REPLACE PACKAGE cities_package AS

PROCEDURE add_cities(city_name VARCHAR2, province_name VARCHAR2);

PROCEDURE remove_cities(city_id NUMBER);

PROCEDURE update_cities(city_id NUMBER, city_name VARCHAR2, province_name VARCHAR2);

END cities_package;
/

CREATE OR REPLACE PACKAGE BODY cities_package AS 

PROCEDURE add_cities(city_name VARCHAR2, province_name VARCHAR2) IS 

BEGIN

INSERT INTO Cities (City, Province) VALUES (city_name, province_name);

END add_cities;

PROCEDURE remove_cities(city_id NUMBER) IS

BEGIN

DELETE FROM Cities WHERE CityId = city_id;

END remove_cities;

PROCEDURE update_cities(city_id NUMBER, city_name VARCHAR2, province_name VARCHAR2) IS

BEGIN

UPDATE Cities SET City = city_name WHERE CityId = city_id;
UPDATE Cities SET Province = province_name WHERE CityId = city_id;

END update_cities;

END cities_package;
/

--Addresses

CREATE OR REPLACE PACKAGE addresses_package AS

PROCEDURE add_addresses(address_name VARCHAR2, city_id NUMBER);

PROCEDURE remove_addresses(address_id NUMBER);

PROCEDURE update_addresses(address_id NUMBER, address_name VARCHAR2);

END addresses_package;
/

CREATE OR REPLACE PACKAGE BODY addresses_package AS 

PROCEDURE add_addresses(address_name VARCHAR2, city_id NUMBER) IS

BEGIN 

INSERT INTO Addresses (Address, CityId) VALUES (address_name, city_id);

END add_addresses;

PROCEDURE remove_addresses(address_id NUMBER) IS

BEGIN

DELETE FROM Addresses WHERE AddressId = address_id;

END remove_addresses;

PROCEDURE update_addresses(address_id NUMBER, address_name VARCHAR2) IS

BEGIN

UPDATE Addresses SET Address = address_name WHERE AddressId = address_id;

END update_addresses;

END addresses_package;
/

--Stores

CREATE OR REPLACE PACKAGE stores_package AS

PROCEDURE add_stores(store_name VARCHAR2);

PROCEDURE remove_stores(store_id NUMBER);

PROCEDURE update_stores(store_id NUMBER, store_name VARCHAR2);

END stores_package;
/

CREATE OR REPLACE PACKAGE BODY stores_package AS 

PROCEDURE add_stores(store_name VARCHAR2) IS

BEGIN

INSERT INTO Stores (StoreName) VALUES (store_name);

END add_stores;

PROCEDURE remove_stores(store_id NUMBER) IS

BEGIN

DELETE FROM Stores WHERE StoreId = store_id;

END remove_stores;

PROCEDURE update_stores(store_id NUMBER, store_name VARCHAR2) IS

BEGIN

UPDATE Stores SET StoreName = store_name WHERE StoreId = store_id;

END update_stores;

END stores_package;
/

--Products

CREATE OR REPLACE PACKAGE products_package AS

PROCEDURE add_products(product_name VARCHAR2, category_name VARCHAR2);

PROCEDURE remove_products(product_id NUMBER);

END products_package;
/

CREATE OR REPLACE PACKAGE BODY products_package AS 

PROCEDURE add_products(product_name VARCHAR2, category_name VARCHAR2) IS 

BEGIN

INSERT INTO Products (ProductName, Category) VALUES (product_name, category_name);

END add_products;

PROCEDURE remove_products(product_id NUMBER) IS 

BEGIN

DELETE FROM Products WHERE ProductId = product_id;

END remove_products;

END products_package;
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


