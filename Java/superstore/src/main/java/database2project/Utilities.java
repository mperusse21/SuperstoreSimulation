package database2project;
import java.sql.*;

/* Contains all methods for searching the database/validation, like getting flagged customers/average review score 
or validating an order */
public class Utilities {
    // Gets the average score of a specified product by calling a stored procedure
    public static Double getAverageScore (Connection conn, int product_id){
        String sql = "{ ? = call reviews_package.get_average_score(?)}";
        Double result = null;
        CallableStatement stmt = null;
        try {
        stmt = conn.prepareCall(sql);
        stmt.registerOutParameter(1, Types.INTEGER);
        stmt.setInt(2, product_id);
        stmt.execute();
        result = stmt.getDouble(1);            
        return result;
        }
        catch (SQLException e){
            e.printStackTrace();
            return result;
        }
        // Always tries to close stmt
        finally {
            try{
                if (!stmt.isClosed() && stmt != null) {
                    stmt.close();
                }
            }
            catch (SQLException e){
                e.printStackTrace();
            }
        }
    }

    public static String validateOrder (Connection conn, int productId, int quantity) {
        String sql = "{ ? = call orders_package.validate_order(?, ?)}";
        CallableStatement stmt = null;
        String result = null;
        try{
        stmt = conn.prepareCall(sql);
        stmt.registerOutParameter(1, Types.VARCHAR);
        stmt.setInt(2, productId);
        stmt.setInt(3, quantity);
        stmt.execute();
        result = stmt.getString(1);
        return result;
        }
        catch (Exception e) {
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
