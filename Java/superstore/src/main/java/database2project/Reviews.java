package database2project;

import java.sql.SQLData;
import java.sql.SQLException;
import java.sql.SQLInput;
import java.sql.SQLOutput;

public class Reviews implements SQLData {
    
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
    public static final String TYPENAME = "REVIEWS_TYP";


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

    //Set methods

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public void setFlag(int flag) {
        this.flag = flag;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    //Optional for now
    public void setProduct(Products product) {
        this.product = product;
    }

    public void setCustomer(Customers customer) {
        this.customer = customer;
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

    //empty constructor to be used for getReview
    public Reviews (){};


    // SQL methods
    @Override 
    public String getSQLTypeName () throws SQLException {
        return Reviews.TYPENAME;
    }
    
    @Override
    public void readSQL (SQLInput stream, String typeName) throws SQLException {
        setReviewId(stream.readInt());
        setProductId(stream.readInt());
        setCustomerId(stream.readInt());
        setScore(stream.readInt());
        setFlag(stream.readInt());
        setDescription(stream.readString());
        }
    
    @Override
    public void writeSQL (SQLOutput stream) throws SQLException {
        stream.writeInt(getReviewId());
        stream.writeInt(getProductId());
        stream.writeInt(getCustomerId());
        stream.writeInt(getScore());
        stream.writeInt(getFlag());
        stream.writeString(getDescription());
    }

    // toString method which returns a string representation of a Review (preliminary)
    public String toString (){
        return "Review " + this.reviewId + " by customer " + this.customerId + " for " + this.product.getProductName() +
        ". Score: " + this.score + " Number of Flags:" + this.flag + "/n Description:" + this.description;
    }   
}
