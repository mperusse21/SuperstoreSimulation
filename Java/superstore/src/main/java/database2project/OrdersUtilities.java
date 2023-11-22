package database2project;

import java.sql.*;

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
}
