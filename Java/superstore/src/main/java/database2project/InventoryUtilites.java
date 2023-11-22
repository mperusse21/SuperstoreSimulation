package database2project;

import java.sql.*;

public class InventoryUtilites {
    // Returns the total stock of a product across all warehouses
    public static int getStock(Connection conn, int warehouse_id, int product_id) {
        String sql = "{ ? = call inventory_package.get_stock(?, ?)}";
        int result = 0;
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.setInt(2, warehouse_id);
            stmt.setInt(3, product_id);
            stmt.execute();
            result = stmt.getInt(1);
            return result;
        } catch (SQLException e) {
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
        
        // In case of error returns -1
        return -1;
    }

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
        
        // In case of error returns -1
        return -1;
    }
}
