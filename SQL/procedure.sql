-- CITIES --

--Package containing all subprograms related to Cities:

--Specification

CREATE OR REPLACE PACKAGE cities_package AS

INVALID_CITY_ID EXCEPTION;

PROCEDURE add_cities(city_name VARCHAR2, province_name VARCHAR2);

PROCEDURE remove_cities(city_id NUMBER);

FUNCTION getCity(city_id NUMBER) RETURN VARCHAR2;

END cities_package;
/

--Body

CREATE OR REPLACE PACKAGE BODY cities_package AS 

--Procedure that inserts a new row (the values of the parameter) in Cities
PROCEDURE add_cities(city_name VARCHAR2, province_name VARCHAR2) IS 
BEGIN
INSERT INTO Cities (City, Province) VALUES (city_name, province_name);
END add_cities;

--Procedure that deletes the row corresponding to the parammeter value in Cities
PROCEDURE remove_cities(city_id NUMBER) IS
BEGIN
DELETE FROM Cities WHERE CityId = city_id;
IF SQL%NOTFOUND THEN
RAISE INVALID_CITY_ID;
END IF;
EXCEPTION
WHEN INVALID_CITY_ID THEN
DBMS_OUTPUT.PUT_LINE('City does not exist');
END remove_cities;

--Function that returns the city corresponding to the CityId value inside the parameter
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

--Triggers 

CREATE OR REPLACE TRIGGER CitiesChange
AFTER INSERT OR DELETE ON Cities
FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:NEW.CityId, 'INSERT', 'CITIES', SYSDATE);
ELSIF DELETING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:OLD.CityId, 'DELETE', 'CITIES', SYSDATE);
END IF;
END CitiesChange;
/

--Anonymous block (for testing)

SELECT * FROM Cities;
SELECT * FROM AuditTable;

DECLARE

city_name VARCHAR2(50);

BEGIN

--cities_package.add_cities('Dorval', 'Quebec');
--cities_package.remove_cities(10);
--city_name := cities_package.getCity(10);
DBMS_OUTPUT.PUT_LINE(city_name);
  
END;
/

-- ADDRESSES --

--Package containing all subprograms related to Addresses:

--Specification

CREATE OR REPLACE PACKAGE addresses_package AS

INVALID_ADDRESS_ID EXCEPTION;

PROCEDURE add_addresses(address_name VARCHAR2, city_id NUMBER);

PROCEDURE remove_addresses(address_id NUMBER);

FUNCTION getAddress(address_id NUMBER) RETURN VARCHAR2;

END addresses_package;
/

--Body

CREATE OR REPLACE PACKAGE BODY addresses_package AS 

--Procedure that inserts a new row (the values of the parameter) in Addresses
PROCEDURE add_addresses(address_name VARCHAR2, city_id NUMBER) IS
BEGIN 
INSERT INTO Addresses (Address, CityId) VALUES (address_name, city_id);
END add_addresses;

--Procedure that deletes the row corresponding to the parammeter value in Addresses
PROCEDURE remove_addresses(address_id NUMBER) IS
BEGIN
DELETE FROM Addresses WHERE AddressId = address_id;
IF SQL%NOTFOUND THEN
RAISE INVALID_ADDRESS_ID;
END IF;
EXCEPTION
WHEN INVALID_ADDRESS_ID THEN
DBMS_OUTPUT.PUT_LINE('Address does not exist');
END remove_addresses;

--Function that returns the address corresponding to the AddressId value in the parameter
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
AFTER INSERT OR DELETE ON Addresses
FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:NEW.AddressId, 'INSERT', 'ADDRESSES', SYSDATE);
ELSIF DELETING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:OLD.AddressId, 'DELETE', 'ADDRESSES', SYSDATE);
END IF;
END AddressesChange;
/

--Anonymous block (for testing)

SELECT * FROM Addresses;
SELECT * FROM AuditTable;

DECLARE

address_name VARCHAR2(50);

BEGIN

--addresses_package.add_addresses('1-825 Rue Richmond', 1);
addresses_package.remove_addresses(19);
--address_name := addresses_package.getAddress(19);
DBMS_OUTPUT.PUT_LINE(address_name);
  
END;
/

-- STORES --

--Package containing all subprograms related to Stores:

--Specification

CREATE OR REPLACE PACKAGE stores_package AS

PROCEDURE add_stores(store_name VARCHAR2);

PROCEDURE remove_stores(store_id NUMBER);

FUNCTION getStore(store_id NUMBER) RETURN VARCHAR2;

END stores_package;
/

--Body

CREATE OR REPLACE PACKAGE BODY stores_package AS 

--Procedure that inserts a new row (the values of the parameter) in Stores
PROCEDURE add_stores(store_name VARCHAR2) IS
BEGIN
INSERT INTO Stores (StoreName) VALUES (store_name);
END add_stores;

--Procedure that deletes the row corresponding to the parammeter value in Stores
PROCEDURE remove_stores(store_id NUMBER) IS
BEGIN
DELETE FROM Stores WHERE StoreId = store_id;
END remove_stores;

--Function that returns the store name corresponding to the StoreId value in the parameter
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

--Anonymous block (for testing)

SELECT * FROM Stores;

DECLARE

store_name VARCHAR2(50);

BEGIN

--stores_package.add_stores('Best Buy');
--stores_package.remove_stores(15);
store_name := stores_package.getStore(15);
DBMS_OUTPUT.PUT_LINE(store_name);
  
END;
/

-- PRODUCTS --

--Package containing all subprograms related to Products:

--Specification

CREATE OR REPLACE PACKAGE products_package AS

PROCEDURE add_products(vproduct IN products_type);

PROCEDURE update_product_name(product_id NUMBER, product_name VARCHAR2);

PROCEDURE update_product_category(product_id NUMBER, category_name VARCHAR2);

TYPE products_name_varray IS VARRAY(100) OF NUMBER;

FUNCTION getAllProductsByCategory(category_name VARCHAR2) RETURN SYS_REFCURSOR;

FUNCTION getProduct(vproductid IN NUMBER) RETURN products_type; 

FUNCTION getAllProducts RETURN SYS_REFCURSOR; 

END products_package;
/

--Body

CREATE OR REPLACE PACKAGE BODY products_package AS 

PROCEDURE add_products(vproduct IN products_type) IS 
BEGIN
INSERT INTO Products (ProductName, Category)
VALUES (vproduct.Productname, vproduct.Category);
END add_products;

--Procedure that updates the product name corresponding to the ProductId value in the parameter with the new value given in the parameter
PROCEDURE update_product_name(product_id NUMBER, product_name VARCHAR2) IS
BEGIN
UPDATE Products SET ProductName = product_name WHERE ProductId = product_id;
END update_product_name;

--Procedure that updates the category corresponding to the ProductId value in the parameter with the new value given in the parameter
PROCEDURE update_product_category(product_id NUMBER, category_name VARCHAR2) IS
BEGIN
UPDATE Products SET Category = category_name WHERE ProductId = product_id;
END update_product_category;

--Function that returns all the Products that are in a certain category (the parameter value)
FUNCTION getAllProductsByCategory(category_name VARCHAR2)
RETURN SYS_REFCURSOR AS all_products SYS_REFCURSOR;
BEGIN
OPEN all_products FOR
SELECT
ProductId, ProductName, Category
FROM
Products
WHERE
Category = category_name;
RETURN all_products;
END getAllProductsByCategory; 

--Function that returns a products_type corresponding to the ProductId value in the parameter
FUNCTION getProduct (vproductid IN NUMBER)
RETURN products_type AS
vproductname VARCHAR2(30);
vcategory VARCHAR2(20);
vproducts products_type;
BEGIN
SELECT
ProductName, Category
INTO
vproductname, vcategory
FROM
Products
WHERE
ProductId = vproductid;
vproducts := products_type(vproductid, vproductname, vcategory);
RETURN vproducts;
END getProduct;

FUNCTION getAllProducts
RETURN SYS_REFCURSOR AS all_products SYS_REFCURSOR;
BEGIN
OPEN all_products FOR
SELECT
ProductId, ProductName, Category
FROM
Products;
RETURN all_products;
END getAllProducts; 

END products_package;
/

--Triggers

CREATE OR REPLACE TRIGGER ProductsUpdate
AFTER INSERT OR UPDATE ON Products
FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:NEW.ProductId, 'INSERT', 'PRODUCTS', SYSDATE);
ELSIF UPDATING THEN
INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) VALUES (:NEW.ProductId, 'UPDATE', 'PRODUCTS', SYSDATE);
END IF;
END CustomersChange;
/

--Anonymous block (for testing)

SELECT * FROM Products;
SELECT * FROM AuditTable;

DECLARE

product_ids products_package.products_name_varray;
product products_type;

BEGIN

--products_package.update_products(17, 'Train X745', 'Vehicle');
product := products_package.getProduct(14);
DBMS_OUTPUT.PUT_LINE(product.ProductName || ' ' || product.Category);
product_ids := products_package.getProductsByCategory('Grocerry');
FOR i IN 1..product_ids.COUNT LOOP
DBMS_OUTPUT.PUT_LINE(product_ids(i));
END LOOP;
  
END;
/

-- CUSTOMERS --

--Package containing all subprograms related to Customers

--Specification

CREATE OR REPLACE PACKAGE customers_package AS

FUNCTION getAllCustomers RETURN SYS_REFCURSOR;

FUNCTION getCustomerByEmail (customer_email VARCHAR2) RETURN customers_type;

FUNCTION getCustomer (vcustomerid NUMBER) RETURN customers_type;

END customers_package;
/

--Body

CREATE OR REPLACE PACKAGE BODY customers_package AS 

FUNCTION getAllCustomers
RETURN SYS_REFCURSOR AS all_customers SYS_REFCURSOR;
BEGIN
OPEN all_customers FOR
SELECT
CustomerId, Firstname, Lastname, Email, AddressId
FROM
Customers;
RETURN all_customers;
END getAllCustomers; 

--Function that returns a customers_type with corresponding email with the parameter value
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

--Function that returns  a customers_type corresponding with the given CustomerId in the parameter
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

--Anonymous block (for testing)

SELECT * FROM Customers;
SELECT * FROM AuditTable;

DECLARE

new_customer customers_type;

BEGIN

new_customer := customers_type(NULL, 'John', 'Doe', 'john.doe@email.com', 3);
customers_package.add_customers(new_customer);
--customers_package.remove_customers();
--customers_package.update_customers(14, 'Johnatahan', 'Doe', 'john.doe@email.com', 1);
--new_customer := customers_package.getCustomerByEmail('msadeghi@dawsoncollege.qc.ca');
--DBMS_OUTPUT.PUT_LINE('getCustomerByEmail function called successfully. Retrieved Customer: ' || new_customer.Firstname || ' ' || new_customer.Lastname);
--new_customer := customers_package.getCustomer(1);
--DBMS_OUTPUT.PUT_LINE('getCustomer function called successfully. Retrieved Customer: ' || new_customer.Firstname || ' ' || new_customer.Lastname);
  
END;
/

CREATE OR REPLACE FUNCTION getAuditTable
RETURN SYS_REFCURSOR AS all_changes SYS_REFCURSOR;
BEGIN
OPEN all_changes FOR
SELECT
AuditId, ChangedId, Action, TableChanged, DateModified
FROM
AuditTable;
RETURN all_changes;
END getAuditTable; 









