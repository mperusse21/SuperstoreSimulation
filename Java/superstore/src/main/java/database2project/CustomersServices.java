package database2project;

import java.sql.*;
import java.util.List;

public class CustomersServices {

    private Connection connection;

    //Constructor that establishes a connection
    public CustomersServices(String username, String password) throws SQLException {
        //Establish the database connection using the provided username and password
        String url = "jdbc:oracle:thin:@198.168.52.211:1521/pdbora19c.dawsoncollege.qc.ca"; 
        this.connection = DriverManager.getConnection(url, username, password);
    }

    //Method to close the database connection
    public void close() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }

    public Customers getCustomerByEmail(String email) throws SQLException, ClassNotFoundException{
        return Customers.getCustomerByEmail(this.connection, email);
    }

    public Customers getCustomerById(int customerId) throws SQLException, ClassNotFoundException{
        return Customers.getCustomerById(this.connection, customerId);
    }

    public String getAddress(int addressId) throws SQLException, ClassNotFoundException{
        return Addresses.getAddress(this.connection, addressId);
    }

    public String getCity(int cityId) throws SQLException, ClassNotFoundException {
        return Cities.getCity(this.connection, cityId);
    }

    public List<Customers> getAllCustomers() throws SQLException, ClassNotFoundException {
        return Customers.getAllCustomers(this.connection);
    }

}
