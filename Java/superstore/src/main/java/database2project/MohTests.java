package database2project;

import java.sql.*;
import java.util.*;

public class MohTests {
    public static void main( String[] args ) {
        Scanner reader = new Scanner(System.in);
        MohServices connection = null;

        try {
            // Prompt user for username and password
            System.out.print("Enter your username: ");
            String user = reader.next();
            String password = new String(System.console().readPassword("Password: "));

            connection = new MohServices(user, password);
            connection.updateProductName(1, "Apple");
            connection.updateProductCategory(1, "Groceryy");
            Customers customer = connection.getCustomerByEmail("msadeghi@dawsoncollege.qc.ca");
            System.out.println(customer);
            Customers anotherCustomer = connection.getCustomerById(2);
            System.out.println(anotherCustomer);
            String address = connection.getAddress(2);
            System.out.println(address);
            String city = connection.getCity(1);
            System.out.println(city);
            connection.addProduct("Broccoli", "Grocery");
            Products product = connection.getProductById(14);
            System.out.println(product);
            List<Products> products = connection.getProductsByCategory("Grocery");
            System.out.println(products.get(1));
            List<AuditTable> audits = connection.getAuditTable();
            for (AuditTable audit : audits) {
                System.out.println(audit);
            } 
            List<Products> allProducts = connection.getAllProducts();
            for (Products allProduct : allProducts ){
                System.out.println(allProduct);
            }
            String store = connection.getStore(2);
            System.out.println(store);
            List<Customers> allCustomers = connection.getAllCustomers();
            for (Customers allCustomer : allCustomers ){
                System.out.println(allCustomer);
            }
        }
        
        // Catches any possible exceptions
        catch (Exception e){
            e.printStackTrace();
        }   

        // Closes the connection and the Scanner
        finally {
            try {
                connection.close();
            } 
            catch (SQLException e) {
                e.printStackTrace();
            }

            reader.close();
        }
     
    }
}

