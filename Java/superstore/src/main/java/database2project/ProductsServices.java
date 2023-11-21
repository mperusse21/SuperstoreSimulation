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

    /*public Products getProductByCategory(String category) throws SQLException, ClassNotFoundException {

        //Products product = new Products();

        Map map = this.connection.getTypeMap();
        map.put("PRODUCTS_TYPE", Class.forName("database2project.Products"));
        this.connection.setTypeMap(map);
        
        String sql = "{ ? = call products_package.getProductsByCategory(?)}";
        try(CallableStatement stmt = this.connection.prepareCall(sql)){
            //stmt.setObject(1, );
            stmt.setObject(2, category);
            stmt.execute();
        }
    }*/

    public void getProductById(int productId) throws SQLException, ClassNotFoundException {

        Map map = this.connection.getTypeMap();
        map.put(Products.TYPENAME, Class.forName("database2project.Products"));
        this.connection.setTypeMap(map);
        
        String sql = "{ ? = call products_package.getProduct(?)}";
        try(CallableStatement stmt = this.connection.prepareCall(sql)){
            stmt.registerOutParameter(1, Types.STRUCT, Products.TYPENAME);
            stmt.setInt(2, productId);
            stmt.execute();
            System.out.println(stmt.getObject(1));
            //Products newProduct = (Products)stmt.getObject(1);
            //System.out.println(newProduct.toString());
            //return newProduct;

        } 
    }
    
}
