package database2project;

import java.sql.*;

public class Inventory implements SQLData {
    
    //Private fields for all fields of the Inventory table
    private int inventoryId;
    private int warehouseId;
    private int productId;
    private int stock;
    public static final String TYPENAME = "INVENTORY_TYP";


    //Getters for the private fields
    public int getInventoryId() {
        return this.inventoryId;
    }

    public int getWarehouseId() {
        return this.warehouseId;
    }
    public int getProductId() {
        return this.productId;
    }
    public int getStock() {
        return this.stock;
    }

    // Set methods
    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    //Constructor initializing all private fields
    public Inventory(int warehouseId, int productId, int stock){
        this.warehouseId = warehouseId;
        this.productId = productId;
        this.stock = stock;
    }

    //empty constructor to be used for getStock PROBABLY NOT NEEDED!!!
    //public Inventory (){};

    // SQL methods
    @Override 
    public String getSQLTypeName () throws SQLException {
        return Inventory.TYPENAME;
    }
    
    @Override
    public void readSQL (SQLInput stream, String typeName) throws SQLException {
        setWarehouseId(stream.readInt());
        setProductId(stream.readInt());
        setStock(stream.readInt());
    }
    
    @Override
    public void writeSQL (SQLOutput stream) throws SQLException {
        stream.writeInt(getWarehouseId());
        stream.writeInt(getProductId());
        stream.writeInt(getStock());
    }

    public String toString (){
        return "Warehouse Id " + this.warehouseId + " Product Id " + this.productId + "\nStock" + this.stock;
    }
       
}
