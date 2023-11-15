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

PROCEDURE update_products(product_id NUMBER, product_name VARCHAR2, category_name VARCHAR2);

TYPE products_name_varray IS VARRAY(100) OF VARCHAR2(30);

FUNCTION getProductNameByCategory(category_name VARCHAR2) RETURN products_name_varray;

END products_package;
/

CREATE OR REPLACE PACKAGE BODY products_package AS 

PROCEDURE update_products(product_id NUMBER, product_name VARCHAR2, category_name VARCHAR2) IS

BEGIN

UPDATE Products SET ProductName = product_name WHERE ProductId = product_id;
UPDATE Products SET Category = category_name WHERE ProductId = product_id;

END update_products;

FUNCTION getProductNameByCategory(category_name VARCHAR2)

RETURN products_name_varray IS
products_name products_name_varray := products_name_varray();

BEGIN

SELECT

ProductName BULK COLLECT INTO products_name FROM Products WHERE Category = category_name;

RETURN products_name;

END getProductNameByCategory;

CREATE TRIGGER ProductsUpdate

AFTER UPDATE ON Products

FOR EACH ROW

BEGIN

INSERT INTO AuditTable () VALUES ();

END products_package;
/

--Customers

CREATE OR REPLACE PACKAGE customers_package AS

PROCEDURE add_customers(vcustomer IN customers_type);

PROCEDURE remove_customers(customer_id NUMBER);

PROCEDURE update_customers(customer_id NUMBER, first_name VARCHAR2, last_name VARCHAR2,
customer_email VARCHAR2, address_id NUMBER);

END customers_package;
/

CREATE OR REPLACE PACKAGE BODY customers_package AS 

PROCEDURE add_customers(vcustomer IN customers_type) IS 

BEGIN

INSERT INTO Customers VALUES (vcustomer.CustomerId, vcustomer.Firstname, vcustomer.Lastname,
vcustomer.Email, vcustomer.AddressId);

END add_customers;

PROCEDURE remove_customers(customer_id NUMBER) IS 

BEGIN

DELETE FROM Customers WHERE CustomerId = customer_id;

END remove_customers;

PROCEDURE update_customers(customer_id NUMBER, first_name VARCHAR2, last_name VARCHAR2,
customer_email VARCHAR2, address_id NUMBER) IS

BEGIN

UPDATE Customers SET Firstname = first_name WHERE CustomerId = customer_id;
UPDATE Customers SET Lastname = last_name WHERE CustomerId = customer_id;
UPDATE Customers SET Email = customer_email WHERE CustomerId = customer_id;
UPDATE Customers SET AddressId = address_id WHERE CustomerId = customer_id;

END update_customers;

END customers_package;
/

CREATE TABLE AuditTable (

AuditId     NUMBER(10)      GENERATED ALWAYS AS IDENTITY,
Action      CHAR(6)         CHECK (Action IN ('INSERT', 'UPDATE', 'DELETE')),


);


