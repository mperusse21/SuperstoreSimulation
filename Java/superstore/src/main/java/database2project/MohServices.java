package database2project;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

public class MohServices {

    private String url = "jdbc:oracle:thin:@198.168.52.211:1521/pdbora19c.dawsoncollege.qc.ca";

    private Connection conn;
    
    //Constructor which takes username and password and creates a connection 
    // (Exceptions will be handled in the application)
    public MohServices (String user, String password) throws SQLException{
        this.conn = DriverManager.getConnection(url, user, password);
        System.out.println("Connected");
    }

    // Method which closes the connection
    public void close () throws SQLException{
        conn.close();
        System.out.println("Disconnected");
    }

    public void updateProductName(int productId, String productName) throws SQLException {

            String sql = "{call products_package.update_product_name(?,?)}";
            try(CallableStatement stmt = this.conn.prepareCall(sql)){
                stmt.setInt(1, productId);
                stmt.setString(2, productName);
                stmt.execute();
            }
    }

    public void updateProductCategory(int productId, String category) throws SQLException {

            String sql = "{call products_package.update_product_category(?,?)}";
            try(CallableStatement stmt = this.conn.prepareCall(sql)){
                stmt.setInt(1, productId);
                stmt.setString(2, category);
                stmt.execute();
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


}
