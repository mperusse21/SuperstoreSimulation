package database2project;

import java.sql.*;
import java.util.Scanner;
import java.util.*;

public class MohTests {
    public static void main( String[] args ) {
        Scanner reader = new Scanner(System.in);
        ProductsServices conn = null;

        try {
            // Prompt user for username and password
            System.out.print("Enter your username: ");
            String user = reader.next();
            String password = new String(System.console().readPassword("Password: "));

            conn = new ProductsServices(user, password);
            //conn.updateProductName(1, "Apple");
            //conn.updateProductCategory(1, "Grocery");
            Products product = conn.getProductById(14);
            System.out.println(product);
            List<Products> products = conn.getProductsByCategory("Grocery");
            System.out.println(products.get(1));
            List<AuditTable> audits = conn.getAuditTable();
            for (AuditTable audit : audits) {
                System.out.println(audit);
            } 
        }
        
        // Catches any possible exceptions
        catch (Exception e){
            e.printStackTrace();
        }   

        // Closes the connection and the Scanner
        finally {
            try {
                conn.close();
            } 
            catch (SQLException e) {
                e.printStackTrace();
            }

            reader.close();
        }
     
    }
}

