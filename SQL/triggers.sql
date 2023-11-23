-- This file contains all triggers used in our database to record changes in the AuditTable

--Cities

CREATE OR REPLACE TRIGGER CitiesChange
AFTER INSERT OR DELETE ON Cities
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) 
        VALUES (:NEW.CityId, 'INSERT', 'CITIES', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.CityId, 'DELETE', 'CITIES', SYSDATE);
    END IF;
END CitiesChange;
/

-- Addresses

CREATE OR REPLACE TRIGGER AddressesChange
AFTER INSERT OR DELETE ON Addresses
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.AddressId, 'INSERT', 'ADDRESSES', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.AddressId, 'DELETE', 'ADDRESSES', SYSDATE);
    END IF;
END AddressesChange;
/

-- Products

CREATE OR REPLACE TRIGGER ProductsUpdate
AFTER INSERT OR UPDATE ON Products
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified) 
        VALUES (:NEW.ProductId, 'INSERT', 'PRODUCTS', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.ProductId, 'UPDATE', 'PRODUCTS', SYSDATE);
    END IF;
END CustomersChange;
/

-- Warehouses

CREATE OR REPLACE TRIGGER WarehousesChange
AFTER INSERT OR UPDATE OR DELETE ON Warehouses
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.WarehouseId, 'INSERT', 'WAREHOUSES', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.WarehouseId, 'DELETE', 'WAREHOUSES', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.WarehouseId, 'UPDATE', 'WAREHOUSES', SYSDATE);
    END IF;
END;
/

-- Inventory

CREATE OR REPLACE TRIGGER InventoryChange
AFTER INSERT OR UPDATE OR DELETE ON Inventory
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.InventoryId, 'INSERT', 'INVENTORY', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.InventoryId, 'DELETE', 'INVENTORY', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.InventoryId, 'UPDATE', 'INVENTORY', SYSDATE);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER OrdersChange
AFTER INSERT OR UPDATE OR DELETE ON Orders
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.OrderId, 'INSERT', 'ORDERS', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.OrderId, 'DELETE', 'ORDERS', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.OrderId, 'UPDATE', 'ORDERS', SYSDATE);
    END IF;
END;
/

-- Reviews

CREATE OR REPLACE TRIGGER ReviewsChange
AFTER INSERT OR UPDATE OR DELETE ON Reviews
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.ReviewId, 'INSERT', 'REVIEWS', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:OLD.ReviewId, 'DELETE', 'REVIEWS', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO AuditTable (ChangedId, Action, TableChanged, DateModified)
        VALUES (:NEW.ReviewId, 'UPDATE', 'REVIEWS', SYSDATE);
    END IF;
END;
/