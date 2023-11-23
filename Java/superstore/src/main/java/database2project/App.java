package database2project;

import java.sql.*;
import java.util.List;
import java.util.Scanner;
public class App 
{
    public static void main( String[] args ) {
        Scanner reader = new Scanner(System.in);
        SuperStoreServices connection = null;
        boolean validLogin = false;
        // Loops until a valid username and password is provided
        while (!validLogin){
            try {
                // Prompt user for username and password
                System.out.print("Enter your username: ");
                String user = reader.next();
                String password = new String(System.console().readPassword("Password: "));
    
                // Creating the connection using the SuperStoreServices object
                connection = new SuperStoreServices(user, password);
                validLogin = true;
            }
            
            // Catches any possible exceptions
            catch (SQLException e){
                System.out.println("Invalid username or password");
            }
        }
        
        try {
            System.out.println("Welcome to our super store!\n");
            boolean exitProgram = false;
            while (!exitProgram) {
                System.out.println("                               \n");
                System.out.println("       | SUPERSTORE MENU |       ");
                System.out.println("----------------------------------");
                System.out.println("| 1 - Account   |  2 - Product   |");
                System.out.println("----------------------------------");
                System.out.println("| 3 - Order     |  4 - Review    |");
                System.out.println("----------------------------------");
                System.out.println("| 5 - Inventory |  6 - History   |");
                System.out.println("----------------------------------");
                System.out.println("| 7 - Exit      |                |");
                System.out.println("----------------------------------\n");
                System.out.println("What would you like to access? (enter the corresponding numerical value)");
                int tableToAccess = setValidAction(reader, 7);

                if (tableToAccess == 1) {
                    accessCustomers(connection, reader);
                }
                else if (tableToAccess == 2) {
                    accessProducts(connection, reader);
                }
                else if (tableToAccess == 3) {
                    accessOrders(connection, reader);
                }
                else if (tableToAccess == 4) {
                    accessReviews(connection, reader);
                }
                else if (tableToAccess == 5) {
                    accessInventory(connection, reader);
                }
                else if (tableToAccess == 6) {
                    accessAudit(connection, reader);
                }
                else if (tableToAccess == 7) {
                    exitProgram = true;
                }

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

    public static void accessCustomers(SuperStoreServices connection, Scanner reader) throws SQLException, ClassNotFoundException {
        boolean exitPage = false;
        while (!exitPage) {
            System.out.println("                                            \n");
            System.out.println("                 | CUSTOMERS |                ");
            System.out.println("----------------------------------------------");
            System.out.println("| 1 - Search All     |  2 - Search By Email  |");
            System.out.println("----------------------------------------------");
            System.out.println("| 3 - Back           |                       |");
            System.out.println("----------------------------------------------\n");
            System.out.println("How would you like to view customers? (enter the corresponding numerical value)");
            int searchMethod = setValidAction(reader, 3);
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
            else if (searchMethod == 3) {
                exitPage = true;
            }
        }
    }

    public static void accessProducts(SuperStoreServices connection, Scanner reader) throws SQLException, ClassNotFoundException {
        boolean exitPage = false;
        while (!exitPage) {
            System.out.println("                                                 \n");
            System.out.println("                  | PRODUCTS |                     ");
            System.out.println("---------------------------------------------------");
            System.out.println("| 1 - Add               |  2 - Update             |");
            System.out.println("---------------------------------------------------");
            System.out.println("| 3 - Search All        |  4 - Search By Category |");
            System.out.println("---------------------------------------------------");
            System.out.println("| 5 - Back              |                         |");
            System.out.println("---------------------------------------------------\n");
            System.out.println("What is the desired action? (enter the corresponding numerical value)");
            int action = setValidAction(reader, 5);
            if (action == 1){
                System.out.println("Enter the name of the new product: ");
                String productName = reader.next();
                System.out.println("Enter the category of the new product: ");
                String category = reader.next();
                connection.addProduct(productName, category);
            }
            else if (action == 2){
                System.out.println("---------------------------------------------------");
                System.out.println("| 1 - Name               |  2 - Category          |");
                System.out.println("---------------------------------------------------");
                System.out.println("Which field would you like to update? (enter the corresponding numerical value)");
                int field = setValidAction(reader, 2);
                if (field == 1) {
                    System.out.println("Enter the product id of the product you wish to modify: ");
                    int productId = reader.nextInt();
                    System.out.println("Enter the new product name: ");
                    String productName = reader.next();
                    connection.updateProductName(productId, productName);
                }
                else if (field == 2) {
                    System.out.println("Enter the product id of the product you wish to modify: ");
                    int productId = reader.nextInt();
                    System.out.println("Enter the new product category: ");
                    String category = reader.next();
                    connection.updateProductCategory(productId, category);
                }

            }
            else if (action == 3){
                List<Products> allProducts = connection.getAllProducts();
                for (Products allProduct : allProducts ){
                    System.out.println(allProduct);
                }
            }
            else if (action == 4){
                System.out.println("Enter your desired product category: ");
                String category = reader.next();
                List<Products> products = connection.getProductsByCategory(category);
                for (Products foundProducts : products ){
                    System.out.println(foundProducts);
                }
            }
            else if (action == 5) {
                exitPage = true;
            }
        }

    }

    public static void accessAudit(SuperStoreServices connection, Scanner reader) throws SQLException, ClassNotFoundException {

        List<AuditTable> audits = connection.getAuditTable();
        if (audits.size() == 0) {
            System.out.println("Your history is empty");
        }
        else {
            System.out.println("                                     | History |                                  ");
            System.out.println("--------------------------------------------------------------------------------\n");
        for (AuditTable audit : audits) {
            System.out.println(audit);
            } 
        }
    }

    public static void accessOrders (SuperStoreServices connection, Scanner reader) {
        System.out.println("                         | Orders |                         ");
        System.out.println("------------------------------------------------------------");
        System.out.println("| 1 - Add                    |  2 - Delete                 |");
        System.out.println("------------------------------------------------------------");
        System.out.println("| 3 - Search Customer Orders |                             |");
        System.out.println("---------------------------------------------------------\n");
        System.out.println("What is the desired action? (enter the corresponding numerical value)");

        
        int action = setValidAction(reader, 3);
        if (action == 1){}
        if (action == 2){}
        if (action == 3){}

    }

        public static void accessReviews (SuperStoreServices connection, Scanner reader) {
        System.out.println("                          | Reviews |                         ");
        System.out.println("--------------------------------------------------------------");
        System.out.println("| 1 - Add                      |  2 - Delete                 |");
        System.out.println("--------------------------------------------------------------");
        System.out.println("| 3 - Update                   |  4 - Search Flagged Reviews |");
        System.out.println("--------------------------------------------------------------");
        System.out.println("| 5 - Search Flagged Customers |  6 - Get Average Score      |");
        System.out.println("-------------------------------------------------------------\n");
        System.out.println("What is the desired action? (enter the corresponding numerical value)");

        int action = setValidAction(reader, 6);
        if (action == 1){}
        if (action == 2){}
        if (action == 3){}
        if (action == 4){}
        if (action == 5){}
        if (action == 6){}

    }

    public static void accessInventory (SuperStoreServices connection, Scanner reader) {
        System.out.println("                         | Inventory |                         ");
        System.out.println("---------------------------------------------------------------");
        System.out.println("| 1 - Update Stock             |  2 - Update Warehouse Name   |");
        System.out.println("---------------------------------------------------------------");
        System.out.println("| 3 - Delete Warehouse         |  4 - Get Total Stock         |");
        System.out.println("--------------------------------------------------------------\n");
        System.out.println("What is the desired action? (enter the corresponding numerical value)");

        int action = setValidAction(reader, 4);
        if (action == 1){}
        if (action == 2){}
        if (action == 3){}
        if (action == 4){}
    }

    public static int setValidAction (Scanner reader, int max) {
        boolean isValid = false;
        int action = 0;
        while (!isValid){
            action = reader.nextInt();
            if (action > 0 && action <= max){
                isValid = true;
            }
            else {
                System.out.println("Invalid input, must be between 1 and " + max);
            }
        }
        return action;
    }
}
