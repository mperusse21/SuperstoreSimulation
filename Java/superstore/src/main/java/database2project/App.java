package database2project;

import java.sql.*;
import java.util.List;
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
            System.out.println("Welcome to our super store!\n");
            System.out.println("       | SUPERSTORE MENU |       ");
            System.out.println("----------------------------------");
            System.out.println("| 1 - Account   |  2 - Product   |");
            System.out.println("----------------------------------");
            System.out.println("| 3 - Order     |  4 - Review    |");
            System.out.println("----------------------------------");
            System.out.println("| 5 - Warehouse |  6 - History   |");
            System.out.println("----------------------------------\n");
            System.out.println("What would you like to access? (enter the corresponding numerical value)");
            int tableToAccess = reader.nextInt();

            if (tableToAccess == 1) {
                accessCustomers(connection);
            }
            else if (tableToAccess == 2) {
                accessProducts(connection);
            }
            else if (tableToAccess == 3) {

            }
            else if (tableToAccess == 4) {

            }
            else if (tableToAccess == 5) {

            }
            else if (tableToAccess == 6) {
                accessAudit(connection);
            }
            else {

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

    public static void accessCustomers(SuperStoreServices connection) throws SQLException, ClassNotFoundException {
        Scanner reader = new Scanner(System.in);
        System.out.println("                 | CUSTOMERS |                ");
        System.out.println("----------------------------------------------");
        System.out.println("| 1 - Search All     |  2 - Search By Email  |");
        System.out.println("----------------------------------------------\n");
        System.out.println("How would you like to view customers? (enter the corresponding numerical value)");
        int searchMethod = reader.nextInt();
        if (searchMethod == 1) {
            List<Customers> allCustomers = connection.getAllCustomers();
            for (Customers allCustomer : allCustomers ){
                System.out.println(allCustomer);
            }
        }
        else if (searchMethod == 2) {
            System.out.println("Please enter email: ");   
            String email = reader.next(); 
            Customers customer = connection.getCustomerByEmail(email);
            String customerAddress = connection.getAddress(customer.getAddressId()); 
            System.out.println("Customer found: " + customer + " Address: " + customerAddress ); 
        }
    }

    public static void accessProducts(SuperStoreServices connection) throws SQLException, ClassNotFoundException {
        Scanner reader = new Scanner(System.in);
        System.out.println("                  | PRODUCTS |                     ");
        System.out.println("---------------------------------------------------");
        System.out.println("| 1 - Add               |  2 - Update             |");
        System.out.println("---------------------------------------------------");
        System.out.println("| 3 - Search All        |  4 - Search By Category |");
        System.out.println("---------------------------------------------------\n");
        System.out.println("What is the desired action? (enter the corresponding numerical value)");

    }

    public static void accessAudit(SuperStoreServices connection) throws SQLException, ClassNotFoundException {

        List<AuditTable> audits = connection.getAuditTable();
        if (audits.size() == 0) {
            System.out.println("Your history is empty");
        }
        else {
            System.out.println("                  | History |                     ");
        for (AuditTable audit : audits) {
            System.out.println(audit);
            } 
        }
    }
}
