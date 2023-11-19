package database2project;

public class Warehouses {

    //Private fields for all fields of the Warehouses table
    private int warehouseId;
    private String warehouseName;
    private int addressId;
    //Optional private field (may not be used)
    private Addresses address;

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

    //Constructor initializing all private fields
    public Warehouses(int warehouseId, String warehouseName, int addressId){
        this.warehouseId = warehouseId;
        this.warehouseName = warehouseName;
        this.addressId = addressId;
    }
}
