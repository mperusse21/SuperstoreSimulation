package database2project;

import java.lang.reflect.Constructor;
import java.sql.*;
import java.util.Map;

import javax.lang.model.type.NullType;


public class Orders implements SQLData {
    
    //Private fields for all fields of the Customers table
    // Used integer to allow nulls
    private Integer orderId;
    private int productId;
    private int customerId;
    private int storeId;
    private int quantity;
    private Double price;
    private Date orderDate;
    //Optional private fields (may not be used)
    private Products product;
    private Customers customer;
    // private Stores store;
    public static final String TYPENAME = "ORDERS_TYP";


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
/*     public Stores getStore(){
        return this.store;
    }*/

    // Set methods
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public void setStoreId(int storeId) {
        this.storeId = storeId;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    // Optional for now
    public void setProduct(Products product) {
        this.product = product;
    }

    public void setCustomer(Customers customer) {
        this.customer = customer;
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

    //empty constructor to be used for getOrder
    public Orders (){};

    // SQL methods
    @Override 
    public String getSQLTypeName () throws SQLException {
        return Orders.TYPENAME;
    }
    
    @Override
    public void readSQL (SQLInput stream, String typeName) throws SQLException {
        setOrderId(stream.readInt());
        setProductId(stream.readInt());
        setCustomerId(stream.readInt());
        setStoreId(stream.readInt());
        setQuantity(stream.readInt());
        setPrice(stream.readDouble());
        setOrderDate(stream.readDate());
    }
    
    @Override
    public void writeSQL (SQLOutput stream) throws SQLException {
        stream.writeInt(getOrderId());
        stream.writeInt(getProductId());
        stream.writeInt(getCustomerId());
        stream.writeInt(getStoreId());
        stream.writeInt(getQuantity());
        stream.writeDouble(getPrice());
        stream.writeDate(getOrderDate());
    }

    //Not sure what to do here yet, might make product into an array of products 
    /*public String toString (){
        String returnString = "Order Id: " + this.orderId + " Customer Id " + this.customerId + " Store Id: " + this.storeId;

        for (Products product : products){
            returnString "/n" + 
        }
    }  */ 

    public String validateOrder (Connection conn) throws SQLException {
        String sql = "{ ? = call orders_package.validate_order(?, ?)}";
        CallableStatement stmt = conn.prepareCall(sql);
        stmt.registerOutParameter(1, Types.VARCHAR);
        stmt.setInt(2, productId);
        stmt.setInt(3, quantity);
        stmt.execute();
        String result = stmt.getString(1);
        return result;
    }

    // Method which adds an order using the add order procedure, along with parameter to generate a key or not
    public void AddToDatabase(Connection conn) throws SQLException, ClassNotFoundException{

        Map map = conn.getTypeMap();
        conn.setTypeMap(map);
        map.put(Orders.TYPENAME,
        Class.forName("database2project.Orders")
        );
        Orders newOrder = new Orders(this.orderId, this.productId, this.customerId, this.storeId, this.quantity, this.price, this.orderDate);
        String sql = "{call orders_package.add_order(?)}";
        CallableStatement stmt = conn.prepareCall(sql);
        stmt.setObject(1, newOrder);
        stmt.execute();
        System.out.println("Successfully added order information");                

        if (!stmt.isClosed() && stmt != null){
            stmt.close();
        } 
    }

}
