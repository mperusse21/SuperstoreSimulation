package database2project;

import java.sql.*;

public class ReviewsUtilities {
    // Gets the average score of a specified product by calling a stored procedure
    public static Double getAverageScore(Connection conn, int product_id) {
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
        } catch (SQLException e) {
            e.printStackTrace();
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

    public static void updateScore(Connection conn, int review_id, int score) {
        String sql = "{ call reviews_package.update_score(?, ?)}";
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, review_id);
            stmt.setInt(2, score);
            stmt.execute();
            System.out.println("Updated review: " + review_id + " score to: " + score);
        } catch (Exception e) {
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
    }

    public static void updateFlag(Connection conn, int review_id, int flag) {
        String sql = "{ call reviews_package.update_flag(?, ?)}";
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, review_id);
            stmt.setInt(2, flag);
            stmt.execute();
            System.out.println("Updated review: " + review_id + " flag to: " + flag);
        } catch (Exception e) {
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
    }

    public static void updateDescription(Connection conn, int review_id, String description) {
        String sql = "{ call reviews_package.update_description(?, ?)}";
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, review_id);
            stmt.setString(2, description);
            stmt.execute();
            System.out.println("Updated review " + review_id + " description to: " + description);
        } catch (Exception e) {
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
    }
}
