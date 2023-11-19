package database2project;

public class Stores {

    //Private fields for all fields of the Stores table
    public int storeId;
    public String storeName;

    //Getters for the private fields
    public int getStoreId(){
        return this.storeId;
    }
    public String getStoreName(){
        return this.storeName;
    }

    //Constructor initializing all private fields
    public Stores(int storeId, String storeName){
        this.storeId = storeId;
        this.storeName = storeName;
    }
    
}
