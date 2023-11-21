package database2project;

import java.sql.*;
import java.util.Scanner;
public class App 
{
    public static void main( String[] args ) {
        Scanner reader = new Scanner(System.in);
        SuperStoreServices connection = null;

        try {
            // Prompt user for username and password
            System.out.print("Enter your username: ");
            String user = reader.next();
            String password = new String(System.console().readPassword("Password: "));

            // Creating the connection using the SuperStoreServices object
            connection = new SuperStoreServices(user, password);

            /* Testing validate order */
            Orders order = new Orders(0, 1,1,1,40,42.50,Date.valueOf("2020-01-01"));
            //System.out.println(order.validateOrder(connection.retrievConnection()));
            order.AddToDatabase(connection.retrievConnection());
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
