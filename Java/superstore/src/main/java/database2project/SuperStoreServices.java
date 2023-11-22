package database2project;
import java.sql.*;

// The plan is to do the try catch here mostly, maybe with some more in the app (on second thought might do it in the object classes)
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

    // Method which returns a string "true" or "false" depending if there is enough quantity of a certain product warehouse.
    public void validateOrder (int productId, int quantity){
        OrdersUtilities.validateOrder(conn, productId, quantity);
    }

    // Method which takes input needed to add an order, creates an Orders object and uses it's built in AddToDatabase method.
    // Also performs validation.
    public void addOrder(int orderId, int productId, int customerId, int storeId, int quantity, Double price, Date orderDate) 
        throws SQLException, ClassNotFoundException{            
            Orders newOrder = new Orders(orderId, productId, customerId, storeId, quantity, price, orderDate);
            if (OrdersUtilities.validateOrder(this.conn, productId, quantity).equals("true")){
            newOrder.AddToDatabase(this.conn);
            }
            else {
                System.out.println("Unable to add order due to lack of stock");
            }
        }
    
    // Method which takes input needed to add a review, creates a Review object and uses it's built in AddToDatabase method.
    public void addReview (int reviewId, int productId, int customerId, int score, 
    String description) throws ClassNotFoundException{
        // Every review is flagged 0 times when added
        Reviews newReview = new Reviews(reviewId, productId, customerId, score, 0, description);
        newReview.AddToDatabase(this.conn);
    }

    // Method which deletes an order from the database using the delete_order procedure
    // (All products for the order will be deleted)
    public void deleteOrder (int order_id){
        Orders.deleteOrder(this.conn, order_id);
    }

    public void deleteReview (int review_id){
        Reviews.deleteReview(this.conn, review_id);
    }

    public void deleteWarehouse (int warehouse_id){
        Warehouses.deleteWarehouse(this.conn, warehouse_id);
    }

    public void updateScore (int review_id, int score){
        ReviewsUtilities.updateScore(this.conn, review_id, score);
    }

    public void updateFlag (int review_id, int flag){
        ReviewsUtilities.updateFlag(this.conn, review_id, flag);
    }

    public void updateDescription (int review_id, String description){
        ReviewsUtilities.updateDescription(this.conn, review_id, description);
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

    // Search methods
    // Gets the average review score for a product
    public Double getAverageScore (int product_id){
        return ReviewsUtilities.getAverageScore(this.conn, product_id);
    }

    public void getFlaggedCustomers (){
        OtherUtilities.getFlaggedCustomers(this.conn);
    }
}

