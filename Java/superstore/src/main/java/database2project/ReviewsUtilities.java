package database2project;

import java.sql.*;
import java.util.*;
/*
 * Class containing all static utility methods relating to the Reviews table, such as updates 
 * and different search queries.
 */
public class ReviewsUtilities {
    /**
     * Gets the average score of a specified product from it's id by calling a stored procedure
     */ 
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

    /**
     * Takes a review id and updates it's score to a provided value.
     */
    public static void updateScore(Connection conn, int review_id, int score) {
        String sql = "{ call reviews_package.update_score(?, ?)}";
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, review_id);
            stmt.setInt(2, score);
            stmt.execute();
            System.out.println("Updated review: " + review_id + " score to: " + score);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error when trying to update review " + review_id + " score");
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

    /**
     * Takes a review id and updates it's flag to a provided value.
     */
    public static void updateFlag(Connection conn, int review_id, int flag) {
        String sql = "{ call reviews_package.update_flag(?, ?)}";
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, review_id);
            stmt.setInt(2, flag);
            stmt.execute();
            System.out.println("Updated review: " + review_id + " flag to: " + flag);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error when trying to update review " + review_id + " flag");
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

    /**
     * Takes a review id and updates it's description to a provided string.
     */
    public static void updateDescription(Connection conn, int review_id, String description) {
        String sql = "{ call reviews_package.update_description(?, ?)}";
        CallableStatement stmt = null;
        try {
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, review_id);
            stmt.setString(2, description);
            stmt.execute();
            System.out.println("Updated review " + review_id + " description to: " + description);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error when trying to update review " + review_id + " description");
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

    // Returns an ArrayList of Customers with more than 1 flagged review.
    // Chose to use RefCursor because it was the easiest Type to get info fron tables.
    // Also because Varray's returned BigDecimals and we weren't sure how to handle.
    public static List<Customers> getFlaggedCustomers(Connection conn) {
        String sql = "{ ? = call reviews_package.get_flagged_customers()}";
        CallableStatement stmt = null;
        List<Customers> customerList = new ArrayList<Customers>(); 
        try {
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.execute();
            ResultSet results = (ResultSet) stmt.getObject(1);
            while (results.next()) {
                Customers foundCustomer = new Customers(results.getInt("CustomerId"), results.getString("Firstname"), 
                    results.getString("Lastname"), results.getString("Email"), results.getInt("AddressId"));
                customerList.add(foundCustomer);
            }
            return customerList;
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

        // If an error occurs or no customers are flagged returns null and prints a message
        System.out.println("Unable to find any flagged customers");
        return null;
    }

    // Returns an ArrayList of Reviews with more than 1 flag.
    public static List<Reviews> getFlaggedReviews(Connection conn) {
        String sql = "{ ? = call reviews_package.get_flagged_reviews()}";
        CallableStatement stmt = null;
        List<Reviews> reviewsList = new ArrayList<Reviews>(); 
        try {
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.execute();
            ResultSet results = (ResultSet) stmt.getObject(1);
            while (results.next()) {
                Reviews foundReview = new Reviews(results.getInt("ReviewId"), results.getInt("ProductId"), 
                results.getInt("CustomerId"), results.getInt("Score"), results.getInt("Flag"), 
                results.getString("Description"));
                reviewsList.add(foundReview);
            }
            return reviewsList;
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
        System.out.println("Unable to find any flagged reviews");
        return null;
    }
}
