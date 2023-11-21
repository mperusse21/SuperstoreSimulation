package database2project;

import java.sql.SQLData;
import java.sql.SQLException;
import java.sql.SQLInput;
import java.sql.SQLOutput;

public class Inventory implements SQLData {
    
    //Private fields for all fields of the Inventory table
    private int warehouseId;
    private int productId;
    private int stock;
    //Optional private fields (may not be used)
    /*private Warehouses warehouse;
    private Products product;*/
    public static final String TYPENAME = "INVENTORY_TYP";


    //Getters for the private fields
    public int getWarehouseId(){
        return this.warehouseId;
    }
    public int getProductId(){
        return this.productId;
    }
    public int getStock(){
        return this.stock;
    }
    //Optional
    /*public Warehouses getWarehouse(){
        return this.warehouse;
    }
    public Products getProduct(){
        return this.product;
    }*/

    // Set methods

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    // Optional for now
    /*public void setWarehouse(Warehouses warehouse) {
        this.warehouse = warehouse;
    }

    public void setProduct(Products product) {
        this.product = product;
    }*/

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
