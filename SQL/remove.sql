-- This file removes all tables, object types, packages and triggers of our database

-- Drop tables:
DROP TABLE Cities CASCADE CONSTRAINTS;
DROP TABLE Addresses CASCADE CONSTRAINTS;
DROP TABLE Stores CASCADE CONSTRAINTS;
DROP TABLE Products CASCADE CONSTRAINTS;
DROP TABLE Customers CASCADE CONSTRAINTS;
DROP TABLE Warehouses CASCADE CONSTRAINTS;
DROP TABLE Inventory CASCADE CONSTRAINTS;
DROP TABLE Reviews CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE AuditTable CASCADE CONSTRAINTS;

-- Drop types:
DROP TYPE warehouse_typ;
DROP TYPE inventory_typ;
DROP TYPE customers_type;
DROP TYPE products_type;
DROP TYPE orders_typ;

-- Drop packages:
DROP PACKAGE cities_package;
DROP PACKAGE addresses_package;
DROP PACKAGE stores_package;
DROP PACKAGE products_package;
DROP PACKAGE customers_package;
DROP PACKAGE warehouses_package;
DROP PACKAGE inventory_package;
DROP PACKAGE reviews_package;
DROP PACKAGE orders_package;

-- Drop Trggers
DROP TRIGGER AddressesChange;
DROP TRIGGER ProductsUpdate;
DROP TRIGGER CustomersChange;
DROP TRIGGER OrdersChange;
DROP TRIGGER  ReviewsChange;
DROP TRIGGER  WarehousesChange;
DROP TRIGGER  InventoryChange;
