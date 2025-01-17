package database2project;

import java.sql.*;
import java.util.List;

public class SuperStoreServices {
    private String url = "jdbc:oracle:thin:@198.168.52.211:1521/pdbora19c.dawsoncollege.qc.ca";
    private Connection conn;

    // Mitchell's methods

    // Constructor which takes username and password and creates a connection
    // (Exceptions will be handled in the application)
    public SuperStoreServices(String user, String password) throws SQLException {
        this.conn = DriverManager.getConnection(url, user, password);
        System.out.println("Connected");
    }

    // Method which closes the connection
    public void close() throws SQLException {
        conn.close();
        System.out.println("Disconnected");
    }

    // Method which returns a string "true" or "false" depending if there is enough
    // quantity of a certain product in a warehouse.
    public String validateOrder(int productId, int quantity) {
        return OrdersUtilities.validateOrder(conn, productId, quantity);
    }

    // Method which takes input needed to add an order, creates an Orders object and
    // uses it's built in AddToDatabase method.
    // Also performs validation.
    public void addOrder(int orderId, int productId, int customerId, int storeId, int quantity, Double price,
            Date orderDate) {
        Orders newOrder = new Orders(orderId, productId, customerId, storeId, quantity, price, orderDate);
        // Does validation here and in SQL for added safety
        if (OrdersUtilities.validateOrder(this.conn, productId, quantity).equals("true")) {
            newOrder.AddToDatabase(this.conn);
        } else {
            System.out.println("Unable to add order due to lack of stock");
        }
    }

    // Method which takes input needed to add a review, creates a Review object and
    // uses it's built in AddToDatabase method.
    public void addReview(int productId, int customerId, int score,
            String description) {
        // Every review is flagged 0 times when added and review id is always generated
        Reviews newReview = new Reviews(0, productId, customerId, score, 0, description);
        newReview.AddToDatabase(this.conn);
    }

    // Method which deletes an order from the database using the delete_order
    // procedure
    // (All products for the order will be deleted)
    public void deleteOrder(int order_id) {
        Orders.deleteOrder(this.conn, order_id);
    }

    public void deleteReview(int review_id) {
        Reviews.deleteReview(this.conn, review_id);
    }

    public void deleteWarehouse(int warehouse_id) {
        Warehouses.deleteWarehouse(this.conn, warehouse_id);
    }

    // Methods for updating columns in various tables

    public void updateScore(int review_id, int score) {
        ReviewsUtilities.updateScore(this.conn, review_id, score);
    }

    public void updateFlag(int review_id, int flag) {
        ReviewsUtilities.updateFlag(this.conn, review_id, flag);
    }

    public void updateDescription(int review_id, String description) {
        ReviewsUtilities.updateDescription(this.conn, review_id, description);
    }

    public void updateStock(int inventory_id, int stock) {
        InventoryUtilites.updateStock(this.conn, inventory_id, stock);
    }

    public void updateWarehouseName(int warehouse_id, String warehouse_name) {
        Warehouses.updateWarehouseName(this.conn, warehouse_id, warehouse_name);
    }

    // Get methods which return objects

    public Orders getOrder(int order_id, int product_id) {
        return Orders.getOrder(this.conn, order_id, product_id);
    }

    public Reviews getReview(int review_id) {
        return Reviews.getReview(this.conn, review_id);
    }

    public Warehouses getWarehouse(int warehouse_id) {
        return Warehouses.getWarehouse(this.conn, warehouse_id);
    }

    // Search methods

    public Double getAverageScore(int product_id) {
        return ReviewsUtilities.getAverageScore(this.conn, product_id);
    }
    
    public int getTotalStock(int product_id) {
        return InventoryUtilites.getTotalStock(this.conn, product_id);
    }

    public List<Customers> getFlaggedCustomers() {
        return ReviewsUtilities.getFlaggedCustomers(this.conn);
    }

    public List<Reviews> getFlaggedReviews() {
        return ReviewsUtilities.getFlaggedReviews(this.conn);
    }

    public List<Orders> getCustomerOrders(int customer_id) {
        return OrdersUtilities.getCustomerOrders(this.conn, customer_id);
    }

    public List<Orders> getAllOrders() {
        return OrdersUtilities.getAllOrders(this.conn);
    }

    public List<Inventory> getAllInventory() {
        return InventoryUtilites.getAllInventory(this.conn);
    }

    public List<Reviews> getAllReviews() {
        return ReviewsUtilities.getAllReviews(conn); 
    }

    // Mohammad's methods

    public void updateProductName(int productId, String productName) throws SQLException {

        String sql = "{call products_package.update_product_name(?,?)}";
        try(CallableStatement stmt = this.conn.prepareCall(sql)){
            stmt.setInt(1, productId);
            stmt.setString(2, productName);
            stmt.execute();
            System.out.println("Product has successfully been updated!");
        }
    }

    public void updateProductCategory(int productId, String category) throws SQLException {

            String sql = "{call products_package.update_product_category(?,?)}";
            try(CallableStatement stmt = this.conn.prepareCall(sql)){
                stmt.setInt(1, productId);
                stmt.setString(2, category);
                stmt.execute();
                System.out.println("Product has successfully been updated!");
            }
    }

    public Customers getCustomerByEmail(String email) throws SQLException, ClassNotFoundException{
        return Customers.getCustomerByEmail(this.conn, email);
    }

    public Customers getCustomerById(int customerId) throws SQLException, ClassNotFoundException{
        return Customers.getCustomerById(this.conn, customerId);
    }

    public String getAddress(int addressId) throws SQLException, ClassNotFoundException{
        return Addresses.getAddress(this.conn, addressId);
    }

    public String getCity(int cityId) throws SQLException, ClassNotFoundException {
        return Cities.getCity(this.conn, cityId);
    }

    public String getProvince(int cityId) throws SQLException, ClassNotFoundException {
        return Cities.getProvince(this.conn, cityId);
    }

    public List<Customers> getAllCustomers() throws SQLException, ClassNotFoundException {
        return Customers.getAllCustomers(this.conn);
    }

    public List<Products> getProductsByCategory(String category) throws SQLException, ClassNotFoundException {
        return Products.getProductsByCategory(this.conn, category);
    }

    public Products getProductById(int productId) throws SQLException, ClassNotFoundException {
        return Products.getProduct(this.conn, productId);
    }

    public List<Products> getAllProducts() throws SQLException, ClassNotFoundException {
        return Products.getAllProducts(this.conn);
    }

    public List<AuditTable> getAuditTable() throws SQLException, ClassNotFoundException {
        return AuditTable.getAuditTable(this.conn);
    }

    public String getStore(int storeId) throws SQLException, ClassNotFoundException {
        return Stores.getStore(this.conn, storeId);
    }

    public void addProduct(String productName, String category) throws SQLException, ClassNotFoundException {            
            Products newProduct = new Products (0, productName, category);
            newProduct.AddToDatabase(this.conn);
        }

    public String getFullLocation(int addressId) throws SQLException, ClassNotFoundException {
        if (addressId == 0) {
            return "";
        }
        else {
            String address = Addresses.getAddress(this.conn, addressId); 
            int cityId = Addresses.getCityId(this.conn, address);
            String city = Cities.getCity(this.conn, cityId);
            String province = Cities.getProvince(this.conn, cityId);
            return " Address: " + address + " | City: " + city + " | Province: " + province;
        }
    }

}
