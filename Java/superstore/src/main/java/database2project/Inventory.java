package database2project;

public class Inventory {
    
    //Private fields for all fields of the Inventory table
    private int warehouseId;
    private int productId;
    private int stock;
    //Optional private fields (may not be used)
    private Warehouses warehouse;
    private Products product;

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
    public Warehouses getWarehouse(){
        return this.warehouse;
    }
    public Products getProduct(){
        return this.product;
    }

    //Constructor initializing all private fields
    public Inventory(int warehouseId, int productId, int stock){
        this.warehouseId = warehouseId;
        this.productId = productId;
        this.stock = stock;
    }
}
