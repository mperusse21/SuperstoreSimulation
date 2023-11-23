package database2project;

import java.sql.SQLException;
import java.util.List;

public class DisplayUtilities {
    public static void displayOrders (SuperStoreServices connection, List<Orders> orders) throws SQLException, ClassNotFoundException{
        for (Orders order : orders){
            Products product = connection.getProductById(order.getProductId());
            Customers customer = connection.getCustomerById(order.getCustomerId());
            System.out.println(order.toString(product, customer));
        }
    }
}
