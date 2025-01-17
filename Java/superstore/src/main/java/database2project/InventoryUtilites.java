package database2project;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Various methods related to Inventory, including update and searches. 
 */
public class InventoryUtilites {
    // Returns the total stock of a product across all warehouses
    public static int getTotalStock(Connection conn, int product_id) {
        String sql = "{ ? = call inventory_package.get_total_stock(?)}";
        int result = 0;
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.setInt(2, product_id);
            stmt.execute();
            result = stmt.getInt(1);
            return result;
        } catch (SQLException e) {
            System.out.println("Unable to get total stock of product " + product_id);
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
        
        // In case of error returns -1
        return -1;
    }

    /**
     * Takes a warehouse id and product id then updates it's stock to a provided value.
     */
    public static void updateStock(Connection conn, int inventory_id, int stock) {
        String sql = "{ call inventory_package.update_stock(?, ?)}";
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, inventory_id);
            stmt.setInt(2, stock);
            stmt.execute();
            System.out.println("Updated inventory " + inventory_id + " stock to: " + stock);
        } catch (SQLException e) {
            System.out.println("Error when trying to update inventory " + inventory_id + " stock");
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

    // Returns a list of all inventory rows in the database.
    public static List<Inventory> getAllInventory(Connection conn) {
        String sql = "{ ? = call inventory_package.get_all_inventory()}";
        CallableStatement stmt = null;
        List<Inventory> inventoryList = new ArrayList<Inventory>(); 
        try {
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.execute();
            ResultSet results = (ResultSet) stmt.getObject(1);
            while (results.next()) {
                Inventory foundInventory = new Inventory(results.getInt("InventoryId"), results.getInt("WarehouseId"), 
                results.getInt("ProductId"), results.getInt("Stock"));
                inventoryList.add(foundInventory);
            }
            return inventoryList;
        } 
        catch (SQLException e) {
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
        
        // If an error occurs returns nulls and prints a message
        System.out.println("Unable to find any inventory");
        return null;
    }
}
