package database2project;

import java.sql.SQLData;
import java.sql.SQLException;
import java.sql.SQLInput;
import java.sql.SQLOutput;

public class Warehouses implements SQLData {
 
    //Private fields for all fields of the Warehouses table
    private int warehouseId;
    private String warehouseName;
    private int addressId;
    //Optional private field (may not be used)
    private Addresses address;
    public static final String TYPENAME = "WAREHOUSE_TYP";

    //Getters for the private fields
    public int getWarehouseId(){
        return this.warehouseId;
    }
    public String getWarehouseName(){
        return this.warehouseName;
    }
    public int getAddressId(){
        return this.addressId;
    }
    //Optional
    public Addresses getAddress(){
        return this.address;
    }

    // Set methods 
    
    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    // Optional
    public void setAddress(Addresses address) {
        this.address = address;
    }

    //Constructor initializing all private fields
    public Warehouses(int warehouseId, String warehouseName, int addressId){
        this.warehouseId = warehouseId;
        this.warehouseName = warehouseName;
        this.addressId = addressId;
    }

    //empty constructor to be used for getWarehouse
    public Warehouses (){};

    // SQL methods
    @Override 
    public String getSQLTypeName () throws SQLException {
        return Warehouses.TYPENAME;
    }
    
    @Override
    public void readSQL (SQLInput stream, String typeName) throws SQLException {
        setWarehouseId(stream.readInt());
        setWarehouseName(stream.readString());
        setAddressId(stream.readInt());
    }
    
    @Override
    public void writeSQL (SQLOutput stream) throws SQLException {
        stream.writeInt(getWarehouseId());
        stream.writeString(getWarehouseName());
        stream.writeInt(getAddressId());
    }
}

