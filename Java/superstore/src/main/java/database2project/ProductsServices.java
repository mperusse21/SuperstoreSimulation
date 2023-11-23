package database2project;

import java.sql.*;
import java.util.*;

public class ProductsServices {

    private Connection connection;

    //Constructor that establishes a connection
    public ProductsServices(String username, String password) throws SQLException {
        // Establish the database connection using the provided username and password
        String url = "jdbc:oracle:thin:@198.168.52.211:1521/pdbora19c.dawsoncollege.qc.ca"; 
        this.connection = DriverManager.getConnection(url, username, password);
    }

    //Method to close the database connection
    public void close() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }

    public void updateProductName(int productId, String productName) throws SQLException {

            String sql = "{call products_package.update_product_name(?,?)}";
            try(CallableStatement stmt = this.connection.prepareCall(sql)){
                stmt.setInt(1, productId);
                stmt.setString(2, productName);
                stmt.execute();
            }
    }

    public void updateProductCategory(int productId, String category) throws SQLException {

            String sql = "{call products_package.update_product_category(?,?)}";
            try(CallableStatement stmt = this.connection.prepareCall(sql)){
                stmt.setInt(1, productId);
                stmt.setString(2, category);
                stmt.execute();
            }
    }

    public List<Products> getProductsByCategory(String category) throws SQLException, ClassNotFoundException {
        return Products.getProductsByCategory(this.connection, category);
    }

    public Products getProductById(int productId) throws SQLException, ClassNotFoundException {
        return Products.getProduct(this.connection, productId);
    }

    public List<Products> getAllProducts() throws SQLException, ClassNotFoundException {
        return Products.getAllProducts(this.connection);
    }

    public List<AuditTable> getAuditTable() throws SQLException, ClassNotFoundException {
        return AuditTable.getAuditTable(this.connection);
    }

    public String getStore(int storeId) throws SQLException, ClassNotFoundException {
        return Stores.getStore(this.connection, storeId);
    }

    public void addProduct(String productName, String category) throws SQLException, ClassNotFoundException {            
            Products newProduct = new Products (0, productName, category);
            newProduct.AddToDatabase(this.connection);
        }

    
}
