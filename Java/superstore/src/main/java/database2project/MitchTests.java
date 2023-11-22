package database2project;

import java.sql.*;
import java.util.List;
import java.util.Scanner;
public class MitchTests 
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
            //connection.addOrder(0, 2,1,1,40,42.50,Date.valueOf("2020-01-01"));
            //System.out.println(order.validateOrder(connection.retrievConnection()));
            //order.AddToDatabase(connection.retrievConnection());

           // Orders order = connection.getOrder(2, 3);

          //Warehouses warehouse = Warehouses.getWarehouse(connection.retrievConnection(), 1);
           //System.out.println(warehouse);

           //Reviews review = connection.getReview(1);
           //System.out.println(review);

           /*Orders order = connection.getOrder(2, 3);
           System.out.println("Order Id: " + order.getOrderId() + " Customer Id " + order.getCustomerId() + " Store Id: " + order.getStoreId());*/

        
            //connection.addReview(0, 1, 1, 2, "This is most test review ever");
            //connection.deleteReview(41);

            //connection.deleteReview(2398);

            //System.out.println(connection.getAverageScore(1));

            //connection.deleteWarehouse(21);
            
           //connection.getFlaggedCustomers();


            //connection.updateScore(61, 5);
            //connection.updateFlag(61,8);
            //connection.updateDescription(61, "Revenge of the test");

            List<Reviews> reviews = connection.getFlaggedReviews();
            for (Reviews review : reviews){
                System.out.println(review);
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
