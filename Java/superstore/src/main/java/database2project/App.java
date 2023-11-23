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
                    String customerAddress = connection.getFullLocation(allCustomer.getAddressId()); 
                    System.out.println(allCustomer + customerAddress);
                }
            }
            else if (searchMethod == 2) {
                System.out.println("Please enter email: ");   
                String email = reader.next(); 
                Customers customer = connection.getCustomerByEmail(email);
                //String customerAddress = connection.getAddress(customer.getAddressId()); 
                String customerAddress = connection.getFullLocation(customer.getAddressId()); 
                System.out.println("Customer found: " + customer + customerAddress); 
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
        System.out.println("| 3 - Search Customer Orders |  4 - Validate               |");
        System.out.println("-----------------------------------------------------------\n");
        System.out.println("What is the desired action? (enter the corresponding numerical value)");

        
        int action = setValidAction(reader, 4);
        if (action == 1){
            //Display the orders table first!!!!
            System.out.println("Adding an order... enter the required information");

            System.out.println("Enter the Order ID to add (or 0 to have a new one generated)");
            int order_id = reader.nextInt();

            System.out.println("Enter the ID of the purchased product");
            int product_id = reader.nextInt();

            System.out.println("Enter the ID of the customer");
            int customer_id = reader.nextInt();

            System.out.println("Enter the ID of the store");
            int store_id = reader.nextInt();

            System.out.println("Enter the price");
            double price = reader.nextDouble();

            System.out.println("Enter the quantity of the product");
            int quantity = reader.nextInt();

            System.out.println("Enter the Order Date in the format (YYYY-MM-DD):");
            String orderDateString = reader.next();
            Date orderDate = Date.valueOf(orderDateString);

            // Tries to add an order
            connection.addOrder(order_id, product_id, customer_id, store_id, quantity, price, orderDate); 
        }
        if (action == 2){
            System.out.println("Enter the ID of the order you would like to delete");
            int order_id = reader.nextInt();
            connection.deleteOrder(order_id);
        }
        if (action == 3){
            // Display the Customers Table!!!
            System.out.println("Enter the ID of the customer whose orders you would like to find");
            int customer_id = reader.nextInt();
            List<Orders> customers = connection.getCustomerOrders(customer_id);
            // Display the table of returned orders!!!
        }

        if (action == 4){
            // Display products table
            System.out.println("Enter a product id");
            int product_id = reader.nextInt();
            System.out.println("Enter a quantity to check if there is enough stock to allow the order");
            int quantity = reader.nextInt();
            System.out.println("Is the order valid: " + connection.validateOrder(product_id, quantity));
        }
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
        if (action == 1){
            System.out.println("Adding a review... enter the required information");
            // Display products
            System.out.println("Enter the ID of the reviewed product");
            int productId = reader.nextInt();
            // Display customers
            System.out.println("Enter the ID of the reviewing customer");
            int customerId = reader.nextInt();

            System.out.println("Enter the score (from 1 to 5)");
            int score = reader.nextInt();
            // Flushes the reader
            reader.nextLine();

            System.out.println("Enter the description");
            String description = reader.nextLine();

            // Review id is always generated and flag always starts at 0.
            connection.addReview(productId, customerId, score, description);
        }
        if (action == 2){
            System.out.println("Enter the ID of the review you would like to delete");
            int review_id = reader.nextInt();
            connection.deleteReview(review_id);
        }
        if (action == 3){
            System.out.println("Enter the ID of the review you'd like to update");
            int review_id = reader.nextInt();
            handleReviewUpdate(reader, connection, review_id);
        }
        if (action == 4){
            List<Reviews> flaggedReviews = connection.getFlaggedReviews();
            // Display the flagged reviews
            System.out.println("Enter the ID of the review you'd like to modify");
            int review_id = reader.nextInt();
            System.out.println("Press 1 to delete the review or 2 to update it (or 0 to return to the menu)");
            int choice = setValidAction(reader, 2);
            if (choice == 1){
                connection.deleteReview(review_id);
            }

            if (choice == 2){
                handleReviewUpdate(reader, connection, review_id);
            }

        }
        if (action == 5){
            List<Customers> flaggedCustomers = connection.getFlaggedCustomers();
            //Display all flagged customers
        }
        if (action == 6){
            // Display the products table
            System.out.println("Enter a product's ID to get it's average review score");
            int product_id = reader.nextInt();
            System.out.println("The average score of product " + product_id + " is: " + connection.getAverageScore(product_id));

        }  
    }

    public static void accessInventory (SuperStoreServices connection, Scanner reader) {
        System.out.println("                         | Inventory |                         ");
        System.out.println("---------------------------------------------------------------");
        System.out.println("| 1 - Update Stock             |  2 - Update Warehouse Name   |");
        System.out.println("---------------------------------------------------------------");
        System.out.println("| 3 - Delete Warehouse         |  4 - Get Total Stock         |");
        System.out.println("--------------------------------------------------------------\n");
        System.out.println("What is the desired action? (enter the corresponding numerical value)");

        // Only need to display the table once at the begginning since warehouse is in the inventory table
        int action = setValidAction(reader, 4);
        if (action == 1){
            System.out.println("Enter the inventory ID you'd like to update");
            int inventory_id = reader.nextInt();
            System.out.println("Enter the new amount of stock");
            int stock = reader.nextInt();
            connection.updateStock(inventory_id, stock);
        }
        if (action == 2){
            System.out.println("Enter the ID of the warehouse you'd like to update");
            int warehouse_id = reader.nextInt();
            System.out.println("Enter the new name");
            // Flushing the scanner
            reader.nextLine();
            String name = reader.nextLine();
            connection.updateWarehouseName(warehouse_id, name);
        }

        if (action == 3){
            System.out.println("Enter the ID of the warehouse you'd like to delete (entering 0 will always return to the menu)");
            int warehouse_id = reader.nextInt();
            connection.deleteWarehouse(warehouse_id);
        }
        if (action == 4){
            // Display products table!!!
            System.out.println("Enter a product ID to get it's total stock");
            int product_id = reader.nextInt();
            System.out.println("The total stock of product " + product_id + " across all warehouses is: " + connection.getTotalStock(product_id));
        }
    }

    public static int setValidAction (Scanner reader, int max) {
        boolean isValid = false;
        int action = 0;
        while (!isValid){
            action = reader.nextInt();
            if (action >= 0 && action <= max){
                isValid = true;
            }
            else {
                System.out.println("Invalid input, must be between 1 and " + max);
            }
        }
        return action;
    }

    public static void handleReviewUpdate(Scanner reader, SuperStoreServices connection, int review_id){
        System.out.println("Choose an update option:");
        System.out.println("1. Update Score");
        System.out.println("2. Update Flag");
        System.out.println("3. Update Description");

        int choice = setValidAction(reader, 3);

        if (choice == 1){
            System.out.println("Enter the new score (from 1 to 5)");
            int score = reader.nextInt();
            connection.updateScore(review_id, score);
        }

        if (choice == 2){
            System.out.println("Enter the new flag value");
            int score = reader.nextInt();
            connection.updateFlag(review_id, score);
        }

        if (choice == 3){
            System.out.println("Enter the new description (or null)");
            // flush the scanner
            reader.nextLine();
            String description = reader.nextLine();
            if (description.equals("null")){
                description = null;
            }
            connection.updateDescription(review_id, description);
        }
    }
}
