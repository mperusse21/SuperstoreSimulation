package database2project;
import java.sql.*;

public class SuperStoreServices {
    private String url = "jdbc:oracle:thin:@198.168.52.211:1521/pdbora19c.dawsoncollege.qc.ca";
    private Connection conn;
    
    //Constructor which takes username and password and creates a connection 
    // (Exceptions will be handled in the application)
    public SuperStoreServices (String user, String password) throws SQLException{
        this.conn = DriverManager.getConnection(url, user, password);
        System.out.println("Connected");
    }

    // Method which closes the connection
    public void close () throws SQLException{
        conn.close();
        System.out.println("Disconnected");
    }

    public Connection retrievConnection (){
        return this.conn;
    }

    // Potentially put various methods like add in here as well
    // Method which takes input needed to add an order, creates an Orders object and uses it's built in AddToDatabase method.
    // Also performs validation.
    public void addOrder(int orderId, int productId, int customerId, int storeId, int quantity, Double price, Date orderDate) 
        throws SQLException, ClassNotFoundException{            
            Orders newOrder = new Orders(orderId, productId, customerId, storeId, quantity, price, orderDate);
            if (newOrder.validateOrder(conn).equals("true")){
            newOrder.AddToDatabase(conn);
            }
            else {
                System.out.println("Unable to add order due to lack of stock");
            }
        }

    // Method which deletes an order from the database using the delete_order procedure
    // (All products for the order will be deleted)
    public void DeleteOrder (int order_id) throws SQLException{
        String sql = "{ call orders_package.delete_order(?)}";
        CallableStatement stmt = this.conn.prepareCall(sql);
        stmt.setInt(1, order_id);
        stmt.execute();
        System.out.println("Removed order " + order_id + " from the database");
    }

    public Orders getOrder (int order_id, int product_id) {
        return Orders.getOrder(this.conn, order_id, product_id);
    }

    public Reviews getReview (int review_id) {
        return Reviews.getReview(this.conn, review_id);
    }

    public Warehouses getWarehouse (int warehouse_id){
        return Warehouses.getWarehouse(this.conn, warehouse_id);
    }
}

