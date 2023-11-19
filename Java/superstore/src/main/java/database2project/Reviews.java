package database2project;

public class Reviews {
    
    //Private fields for all fields of the Inventory table
    private int reviewId;
    private int productId;
    private int customerId;
    private int score;
    private int flag;
    private String description;
    //Optional private fields (may not be used)
    private Products product;
    private Customers customer;

    //Getters for the private fields
    public int getReviewId(){
        return this.reviewId;
    }
    public int getProductId(){
        return this.productId;
    }
    public int getCustomerId(){
        return this.customerId;
    }
    public int getScore(){
        return this.score;
    }
    public int getFlag(){
        return this.flag;
    }
    public String getDescription(){
        return this.description;
    }
    //Optional
    public Products getProduct(){
        return this.product;
    }
    public Customers getCustomer(){
        return this.customer;
    }
    
    //Constructor initializing all private fields
    public Reviews(int reviewId, int productId, int customerId, int score, int flag, String description){
        this.reviewId = reviewId;
        this.productId = productId;
        this.customerId = customerId;
        this.score = score;
        this.flag = flag;
        this.description = description;
    }
}
