package database2project;

public class Products {

    //Private fields for all fields of the Products table
    private int productId;
    private String productName;
    private String category; 

    //Getters for the private fields
    public int getProductId(){
        return this.productId;
    }
    public String getProductName(){
        return this.productName;
    }
    public String getCategory(){
        return this.category;
    }
    
    //Constructor initializing all private fields
    public Products(int productId, String productName, String category){
        this.productId = productId;
        this.productName = productName;
        this.category = category;
    }
}
