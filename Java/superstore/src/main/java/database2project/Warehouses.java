package database2project;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLData;
import java.sql.SQLException;
import java.sql.SQLInput;
import java.sql.SQLOutput;
import java.sql.Types;
import java.util.Map;

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

    // toString method which returns a string representation of a Warehouse (preliminary)
    public String toString (){
        return "Warehouse Id: " + this.warehouseId + ", " + this.warehouseName + ", Address Id:" + this.addressId;
    }   

    public static Warehouses getWarehouse(Connection conn, int warehouse_id) {
        String sql = "{ ? = call warehouses_package.get_warehouse(?) }";
        CallableStatement stmt = null;
        Warehouses foundWarehouse = null;
        try {
            // Couldn't get it working without mapping so added
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put(Warehouses.TYPENAME,
                    Class.forName("database2project.Warehouses"));
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.STRUCT, Warehouses.TYPENAME);
            stmt.setInt(2, warehouse_id);
            stmt.execute();
            foundWarehouse = (Warehouses) stmt.getObject(1);
            return foundWarehouse;
        } 
        catch (Exception e) {
            e.printStackTrace();
            // If an error occurs returns null
            return foundWarehouse;
        }
        // Always tries to close stmt
        finally {
            try {
                if (!stmt.isClosed() && stmt != null) {
                    stmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

