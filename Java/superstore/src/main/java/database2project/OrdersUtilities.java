package database2project;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrdersUtilities {
    public static String validateOrder(Connection conn, int productId, int quantity) {
        String sql = "{ ? = call orders_package.validate_order(?, ?)}";
        CallableStatement stmt = null;
        String result = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.VARCHAR);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            stmt.execute();
            result = stmt.getString(1);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            // Will return null if an error occurs
            return result;
        }
        // Always tries to close stmt
        finally {
            try {
                if (!stmt.isClosed() && stmt != null) {
                    stmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Returns an ArrayList of Orders by a specific customer.
    public static List<Orders> getCustomerOrders(Connection conn, int customer_id) {
        String sql = "{ ? = call orders_package.get_customer_orders(?)}";
        CallableStatement stmt = null;
        List<Orders> ordersList = new ArrayList<Orders>(); 
        try {
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.setInt(2, customer_id);
            stmt.execute();
            ResultSet results = (ResultSet) stmt.getObject(1);
            while (results.next()) {
                Orders foundOrder = new Orders(results.getInt("OrderId"), results.getInt("ProductId"), 
                results.getInt("CustomerId"), results.getInt("StoreId"), results.getInt("Quantity"), 
                results.getDouble("Price"), results.getDate("OrderDate"));
                ordersList.add(foundOrder);
            }
            return ordersList;
        } 
        catch (SQLException e) {
            e.printStackTrace();
        }
        // Always tries to close stmt
        finally {
            try {
                if (!stmt.isClosed() && stmt != null) {
                    stmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // If an error occurs or no reviews are flagged returns null and prints a message
        System.out.println("Unable to find any orders by this customer");
        return null;
    }
}
