-- CITIES --

--Specification

CREATE OR REPLACE PACKAGE cities_package AS

PROCEDURE add_cities(city_name VARCHAR2, province_name VARCHAR2);

PROCEDURE remove_cities(city_id NUMBER);

FUNCTION getCity(city_id NUMBER) RETURN VARCHAR2;

END cities_package;
/

--Body

CREATE OR REPLACE PACKAGE BODY cities_package AS 

PROCEDURE add_cities(city_name VARCHAR2, province_name VARCHAR2) IS 
BEGIN
INSERT INTO Cities (City, Province) VALUES (city_name, province_name);
END add_cities;

PROCEDURE remove_cities(city_id NUMBER) IS
BEGIN
DELETE FROM Cities WHERE CityId = city_id;
END remove_cities;

FUNCTION getCity(city_id NUMBER)
RETURN VARCHAR2 IS
city_name VARCHAR2(50);   
BEGIN
SELECT
City INTO city_name FROM Cities WHERE CityId = city_id;
RETURN city_name;
END getCity;

END cities_package;
/

--Triggers (not working)

CREATE OR REPLACE TRIGGER CitiesChange
AFTER UPDATE ON Cities
FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:NEW.CityId, 'INSERT', 'CITIES', SYSDATE);
ELSIF DELETING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:OLD.CityId, 'REMOVE', 'CITIES', SYSDATE);
END IF;
END CitiesChange;
/

--Anonymous block

SELECT * FROM Cities;
SELECT * FROM AuditTable;

DECLARE

city_name VARCHAR2(50);

BEGIN

--cities_package.add_cities('Dorval', 'Quebec');
--cities_package.remove_cities();
city_name := cities_package.getCity(7);
DBMS_OUTPUT.PUT_LINE(city_name);
  
END;
/

-- ADDRESSES --

--Specification

CREATE OR REPLACE PACKAGE addresses_package AS

PROCEDURE add_addresses(address_name VARCHAR2, city_id NUMBER);

PROCEDURE remove_addresses(address_id NUMBER);

FUNCTION getAddress(address_id NUMBER) RETURN VARCHAR2;

END addresses_package;
/

--Body

CREATE OR REPLACE PACKAGE BODY addresses_package AS 

PROCEDURE add_addresses(address_name VARCHAR2, city_id NUMBER) IS
BEGIN 
INSERT INTO Addresses (Address, CityId) VALUES (address_name, city_id);
END add_addresses;

PROCEDURE remove_addresses(address_id NUMBER) IS
BEGIN
DELETE FROM Addresses WHERE AddressId = address_id;
END remove_addresses;

FUNCTION getAddress(address_id NUMBER)
RETURN VARCHAR2 IS
address_name VARCHAR2(50);   
BEGIN
SELECT
Address INTO address_name FROM Addresses WHERE AddressId = address_id;
RETURN address_name;
END getAddress;

END addresses_package;
/

--Triggers

CREATE OR REPLACE TRIGGER AddressesChange
AFTER UPDATE ON Addresses
FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:NEW.AddressId, 'INSERT', 'ADDRESSES', SYSDATE);
ELSIF DELETING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:OLD.AddressId, 'REMOVE', 'ADDRESSES', SYSDATE);
END IF;
END AddressesChange;
/

--Anonymous block

SELECT * FROM Addresses;
SELECT * FROM AuditTable;

DECLARE

address_name VARCHAR2(50);

BEGIN

--addresses_package.add_addresses('1-825 Rue Richmond', 1);
--addresses_package.remove_addresses();
address_name := addresses_package.getAddress(13);
DBMS_OUTPUT.PUT_LINE(address_name);
  
END;
/

-- STORES --

--Specification

CREATE OR REPLACE PACKAGE stores_package AS

PROCEDURE add_stores(store_name VARCHAR2);

PROCEDURE remove_stores(store_id NUMBER);

FUNCTION getStore(store_id NUMBER) RETURN VARCHAR2;

END stores_package;
/

--Body

CREATE OR REPLACE PACKAGE BODY stores_package AS 

PROCEDURE add_stores(store_name VARCHAR2) IS
BEGIN
INSERT INTO Stores (StoreName) VALUES (store_name);
END add_stores;

PROCEDURE remove_stores(store_id NUMBER) IS
BEGIN
DELETE FROM Stores WHERE StoreId = store_id;
END remove_stores;

FUNCTION getStore(store_id NUMBER)
RETURN VARCHAR2 IS
store_name VARCHAR2(50);   
BEGIN
SELECT
StoreName INTO store_name FROM Stores WHERE StoreId = store_id;
RETURN store_name;
END getStore;

END stores_package;
/

--Anonymous block

SELECT * FROM Stores;

DECLARE

store_name VARCHAR2(50);

BEGIN

stores_package.add_stores('Best Buy');
--stores_package.remove_stores();
store_name := stores_package.getStore(10);
DBMS_OUTPUT.PUT_LINE(store_name);
  
END;
/

--PRODUCTS--

--Alternate type:

CREATE OR REPLACE TYPE products_info_table_type AS TABLE OF products_type;

--Specification

CREATE OR REPLACE PACKAGE products_package AS

PROCEDURE update_products(product_id NUMBER, product_name VARCHAR2, category_name VARCHAR2);

PROCEDURE remove_products(product_id NUMBER);

TYPE products_name_varray IS VARRAY(100) OF NUMBER;

FUNCTION getProductsByCategory(category_name VARCHAR2) RETURN products_name_varray;

END products_package;
/

CREATE OR REPLACE PACKAGE BODY products_package AS 

PROCEDURE update_products(product_id NUMBER, product_name VARCHAR2, category_name VARCHAR2) IS
BEGIN
UPDATE Products SET ProductName = product_name WHERE ProductId = product_id;
UPDATE Products SET Category = category_name WHERE ProductId = product_id;
END update_products;

FUNCTION getProductsByCategory(category_name VARCHAR2)
RETURN products_name_varray IS
products_id products_name_varray := products_name_varray();
BEGIN
SELECT
ProductId BULK COLLECT INTO products_id FROM Products WHERE Category = category_name;
RETURN products_id;
END getProductsByCategory;

END products_package;
/

--Triggers

CREATE OR REPLACE TRIGGER ProductsUpdate
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:NEW.ProductId, 'UPDATE', 'PRODUCTS', SYSDATE);
END ProductsUpdate;

--Anonymous block

SELECT * FROM Products;
SELECT * FROM AuditTable;

DECLARE

TYPE products_name_varray IS VARRAY(100) OF NUMBER;
product_ids products_package.products_name_varray;

BEGIN

products_package.update_products(17, 'Train X745', 'Vehicle');
product_ids := products_package.getProductsByCategory('Grocery');
FOR i IN 1..product_ids.COUNT LOOP
DBMS_OUTPUT.PUT_LINE(product_ids(i));
END LOOP;
  
END;
/

--Alternate function

CREATE OR REPLACE FUNCTION getProductsByCategory (category_name VARCHAR2)
RETURN products_info_table_type IS
v_products products_info_table_type := products_info_table_type(); 
BEGIN
FOR product_info IN (SELECT * FROM Products WHERE category = category_name) LOOP
v_products.EXTEND;
v_products(v_products.LAST) := products_type(
product_info.ProductId,
product_info.ProductName,
product_info.Category
);
END LOOP;
RETURN v_products;
END getProductsByCategory;
/

--Anonymous block for testing alternate function

DECLARE
v_products products_info_table_type;
BEGIN
v_products := getProductsByCategory('Grocery');
FOR i IN 1..v_products.COUNT LOOP
DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_products(i).ProductId ||
', Name: ' || v_products(i).ProductName ||
', Category: ' || v_products(i).Category);
END LOOP;
END;
/

--CUSTOMERS--

--Specification

CREATE OR REPLACE PACKAGE customers_package AS

PROCEDURE add_customers(vcustomer IN customers_type);

PROCEDURE remove_customers(customer_id NUMBER);

PROCEDURE update_customers(customer_id NUMBER, first_name VARCHAR2, last_name VARCHAR2,
customer_email VARCHAR2, address_id NUMBER);

FUNCTION getCustomerByEmail (customer_email VARCHAR2) RETURN customers_type;

FUNCTION getCustomer (vcustomerid NUMBER) RETURN customers_type;

END customers_package;
/

--Body

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

FUNCTION getCustomerByEmail (customer_email VARCHAR2)
RETURN customers_type AS
vcustomerid NUMBER(5);
vfirstname VARCHAR2(20); 
vlastname VARCHAR2(20); 
vemail VARCHAR2(30);
vaddressid NUMBER(5);
vcustomer customers_type;
BEGIN
SELECT
CustomerId, Firstname,  Lastname,  Email, AddressId
INTO
vcustomerid, vfirstname, vlastname, vemail, vaddressid
FROM
Customers
WHERE
Email = customer_email;
vcustomer := customers_type(vcustomerid, vfirstname, vlastname, vemail, vaddressid);
RETURN vcustomer;
END getCustomerByEmail;

FUNCTION getCustomer (vcustomerid NUMBER)
RETURN customers_type AS
vfirstname VARCHAR2(20);
vlastname VARCHAR2(20);
vemail VARCHAR2(30);
vaddressid NUMBER(5);
vcustomers customers_type;
BEGIN
SELECT
Firstname, Lastname, Email, AddressId
INTO
vfirstname, vlastname, vemail, vaddressid
FROM
Customers
WHERE
CustomerId = vcustomerid;
vcustomers := customers_type(vcustomerid, vfirstname, vlastname, vemail, vaddressid);
RETURN vcustomers;
END getCustomer;

END customers_package;
/

--Triggers

CREATE OR REPLACE TRIGGER CustomersChange
AFTER INSERT OR UPDATE OR DELETE ON Customers
FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
VALUES (:NEW.CustomerId, 'INSERT', 'CUSTOMERS', SYSDATE);
ELSIF DELETING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
VALUES (:OLD.CustomerId,'DELETE', 'CUSTOMERS', SYSDATE);
ELSIF UPDATING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
VALUES (:NEW.CustomerId, 'UPDATE', 'CUSTOMERS', SYSDATE);
END IF;
END CustomersChange;
/

--Anonymous block

SELECT * FROM Customers;
SELECT * FROM AuditTable;

DECLARE

new_customer customers_package.customers_type;

BEGIN

new_customer := customers_package.customers_type(14, 'John', 'Doe', 'john.doe@email.com', 3);
customers_package.add_customers(new_customer);
--customers_package.remove_customers(14);
--customers_package.update_customers(14, 'Johnatahan', 'Doe', 'john.doe@email.com', 1);
new_customer := customers_package.getCustomerByEmail('john.doe@email.com');
DBMS_OUTPUT.PUT_LINE('getCustomerByEmail function called successfully. Retrieved Customer: ' || new_customer.Firstname || ' ' || new_customer.Lastname);
new_customer := customers_package.getCustomer(1);
DBMS_OUTPUT.PUT_LINE('getCustomer function called successfully. Retrieved Customer: ' || new_customer.Firstname || ' ' || new_customer.Lastname);
  
END;
/

-- Audit Table

CREATE TABLE AuditTable (

AuditId         NUMBER(10)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

ChangedId       NUMBER(5),

Action          CHAR(6)         CHECK (Action IN ('INSERT', 'UPDATE', 'DELETE')),

TableChanged    VARCHAR2(10)    CHECK (TableChanged IN ('PROVINCES', 'CITIES', 'ADDRESSES',
'STORES', 'PRODUCTS', 'CUSTOMERS', 'WAREHOUSES', 'INVENTORY', 'REVIEWS', 'ORDERS')),

DateModified    Date

);

DROP TABLE AuditTable CASCADE CONSTRAINTS;





