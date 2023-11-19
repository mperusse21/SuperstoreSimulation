package database2project;

import java.sql.*;

public class Orders {
    
    //Private fields for all fields of the Customers table
    private int orderId;
    private int productId;
    private int customerId;
    private int storeId;
    private int quantity;
    private Double price;
    private Date orderDate;
    //Optional private fields (may not be used)
    private Products product;
    private Customers customer;
    private Stores store;

    //Getters for the private fields
    public int getOrderId(){
        return this.orderId;
    }
    public int getProductId(){
        return this.productId;
    }
    public int getCustomerId(){
        return this.customerId;
    }
    public int getStoreId(){
        return this.storeId;
    }
    public int getQuantity(){
        return this.quantity;
    }
    public Double getPrice(){
        return this.price;
    }
    public Date getOrderDate(){
        return this.orderDate;
    }
    //Optional
    public Products getProduct(){
        return this.product;
    }
    public Customers getCustomer(){
        return this.customer;
    }
    public Stores getStore(){
        return this.store;
    }
 
    //Constructor initializing all private fields
    public Orders(int orderId, int productId, int customerId, int storeId, int quantity, Double price, Date orderDate){
        this.orderId = orderId;
        this.productId = productId;
        this.customerId = customerId;
        this.storeId = storeId;
        this.quantity = quantity;
        this.price = price;
        this.orderDate = orderDate;
    }
}
