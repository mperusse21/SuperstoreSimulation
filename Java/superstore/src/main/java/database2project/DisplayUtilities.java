package database2project;

import java.sql.SQLException;
import java.util.List;

public class DisplayUtilities {
    public static void displayOrders (SuperStoreServices connection, List<Orders> orders) throws SQLException, ClassNotFoundException{
        for (Orders order : orders){
            Products product = connection.getProductById(order.getProductId());
            Customers customer = connection.getCustomerById(order.getCustomerId());
            String storeName = connection.getStore(order.getStoreId());
            String fullLocation = connection.getFullLocation(customer.getAddressId());
            System.out.println(order.toString(product, customer, storeName, fullLocation));
        }
    }

    public static void displayReviews (SuperStoreServices connection, List<Reviews> reviews) throws SQLException, ClassNotFoundException{
        for (Reviews review : reviews){
            Products product = connection.getProductById(review.getProductId());
            Customers customer = connection.getCustomerById(review.getCustomerId());
            String fullLocation = connection.getFullLocation(customer.getAddressId());
            System.out.println(review.toString(product, customer, fullLocation));
        }
    }

    public static void displayAllProducts (SuperStoreServices connection) throws ClassNotFoundException, SQLException{
        System.out.println("\n|All Products|\n");
        List<Products> allProducts = connection.getAllProducts();
        for (Products allProduct : allProducts ){
            System.out.println(allProduct);
        }                
    }

    public static void displayAllCustomers (SuperStoreServices connection) throws ClassNotFoundException, SQLException{
        System.out.println("\n|All Customers|\n");
        List<Customers> allCustomers = connection.getAllCustomers();
        for (Customers allCustomer : allCustomers ){
            System.out.println(allCustomer);
        }              
    }

    public static void displayAllInventory (SuperStoreServices connection) throws ClassNotFoundException, SQLException {
        System.out.println("\n|All Inventory|\n");
        List<Inventory> allInventory = connection.getAllInventory();
        for (Inventory inventory : allInventory ){
            Warehouses warehouse = connection.getWarehouse(inventory.getWarehouseId());
            String fullLocation = connection.getFullLocation(warehouse.getAddressId());
            System.out.println(inventory.toString(warehouse, fullLocation));
        }     
    }

    public static void displayAllReviews (SuperStoreServices connection) throws ClassNotFoundException, SQLException {
        System.out.println("\n|All Inventory|\n");
        List<Reviews> allReviews = connection.getAllReviews();
        for (Reviews review : allReviews ){
            Products product = connection.getProductById(review.getProductId());
            Customers customer = connection.getCustomerById(review.getCustomerId());
            String fullLocation = connection.getFullLocation(customer.getAddressId());
            System.out.println(review.toString(product, customer, fullLocation));
        }     
    }
}
