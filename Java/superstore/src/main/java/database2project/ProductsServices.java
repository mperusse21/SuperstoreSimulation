package database2project;

import java.sql.*;
import java.util.Map;

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

    public void updateProduct(int productId, String productName, String category) throws SQLException, ClassNotFoundException {

            String sql = "{call products_package.update_products(?,?,?)}";
            try(CallableStatement stmt = this.connection.prepareCall(sql)){
                stmt.setInt(1, productId);
                stmt.setString(2, productName);
                stmt.setString(3, category);
                stmt.execute();
            }
    }

    public Products getProductByCategory(String category){
        throw new UnsupportedOperationException();
    }

    public Products getProductById(int productId){
        throw new UnsupportedOperationException();
    }
    
}
