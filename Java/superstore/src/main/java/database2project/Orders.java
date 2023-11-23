package database2project;

import java.sql.*;
import java.util.Map;

public class Orders implements SQLData {
    
    //Private fields for all fields of the Orders table
    private int orderId;
    private int productId;
    private int customerId;
    private int storeId;
    private int quantity;
    private Double price;
    private Date orderDate;
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

    // Returns a string representation of an order.
    // (Takes a product, customer, and strings representing the full address and store name)
    public String toString (Products p, Customers c, String storeName, String fullLocation){
        return "| Order Id: " + this.orderId  + c.toString() + fullLocation +
        "\n" + p.toString() + " Quantity: " + this.quantity + " | Price: " + this.price + " | Order Date: "
        + this.orderDate + "| Store ID: " + this.storeId + " | Store Name: " + storeName + "\n";
    }  

    // Method which adds an order using the add_order procedure
    public void AddToDatabase(Connection conn) {
        String sql = "{ call orders_package.add_order(?)}";
        CallableStatement stmt = null;
        try {
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put(Orders.TYPENAME,
            Class.forName("database2project.Orders")
            );
            Orders newOrder = new Orders(this.orderId, this.productId, this.customerId, 
                this.storeId, this.quantity, this.price, this.orderDate);
            stmt = conn.prepareCall(sql);
            stmt.setObject(1, newOrder);
            stmt.execute();
            System.out.println("Successfully added order information to the database"); 
        }      
        catch (Exception e) {
            System.out.println("Unable to add given order");
        }
        // Always tries to close stmt
        finally {
            try{
                if (!stmt.isClosed() && stmt != null) {
                    stmt.close();
                }
            }
            catch (SQLException e){
                e.printStackTrace();
            }
        }         
    }

    public static void deleteOrder (Connection conn, int order_id){
        String sql = "{ call orders_package.delete_order(?)}";
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, order_id);
            stmt.execute();
            System.out.println("Removed order " + order_id + " from the database");
        }
        catch (Exception e) {
            System.out.println("Unable to delete order " + order_id);
        }
        // Always tries to close stmt
        finally {
            try{
                if (!stmt.isClosed() && stmt != null) {
                    stmt.close();
                }
            }
            catch (SQLException e){
                e.printStackTrace();
            }
        }
    }

    /* Gets an order using the composite primary key (orderid and productid) and calling the sql get order function*/
    public static Orders getOrder(Connection conn, int order_id, int product_id) {
        String sql = "{ ? = call orders_package.get_order(?, ?)}";
        Orders foundOrder = null;
        CallableStatement stmt = null;
        try {
            // Couldn't get it working without mapping so added
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put(Orders.TYPENAME,
                    Class.forName("database2project.Orders"));
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.STRUCT, "ORDERS_TYP");
            stmt.setInt(2, order_id);
            stmt.setInt(3, product_id);
            stmt.execute();
            foundOrder = (Orders) stmt.getObject(1);
            return foundOrder;
        } 
        catch (Exception e) {
            System.out.println("Unable to get order " + order_id);
            // Will return a null found order if an error occurs
            return foundOrder;
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
