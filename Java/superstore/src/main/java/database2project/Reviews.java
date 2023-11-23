package database2project;

import java.sql.*;
import java.util.Map;

public class Reviews implements SQLData {
    
    //Private fields for all fields of the Reviews table
    private int reviewId;
    private int productId;
    private int customerId;
    private int score;
    private int flag;
    private String description;
    public static final String TYPENAME = "REVIEWS_TYP";


    //Getters for the private fields
    public int getReviewId(){
        return this.reviewId;
    }
    public int getProductId(){
        return this.productId;
    }
    public int getCustomerId(){
        return this.customerId;
    }
    public int getScore(){
        return this.score;
    }
    public int getFlag(){
        return this.flag;
    }
    public String getDescription(){
        return this.description;
    }

    //Set methods

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public void setFlag(int flag) {
        this.flag = flag;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    //Constructor initializing all private fields
    public Reviews(int reviewId, int productId, int customerId, int score, int flag, String description){
        this.reviewId = reviewId;
        this.productId = productId;
        this.customerId = customerId;
        this.score = score;
        this.flag = flag;
        this.description = description;
    }

    //empty constructor to be used for getReview
    public Reviews (){};


    // SQL methods
    @Override 
    public String getSQLTypeName () throws SQLException {
        return Reviews.TYPENAME;
    }
    
    @Override
    public void readSQL (SQLInput stream, String typeName) throws SQLException {
        setReviewId(stream.readInt());
        setProductId(stream.readInt());
        setCustomerId(stream.readInt());
        setScore(stream.readInt());
        setFlag(stream.readInt());
        setDescription(stream.readString());
        }
    
    @Override
    public void writeSQL (SQLOutput stream) throws SQLException {
        stream.writeInt(getReviewId());
        stream.writeInt(getProductId());
        stream.writeInt(getCustomerId());
        stream.writeInt(getScore());
        stream.writeInt(getFlag());
        stream.writeString(getDescription());
    }

    // toString method which returns a string representation of a Review (preliminary)
    public String toString (Products p, Customers c){
        return "| Review Id " + this.reviewId  + c.toString() + "\n" + p.toString() + 
        " Score: " + this.score + " | Flags: " + this.flag + " | Description: " + this.description + "\n";
    }
       
    // Method which adds an review using the add_review procedure
    public void AddToDatabase(Connection conn) {
        CallableStatement stmt = null;
        try {
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put(Reviews.TYPENAME,
                    Class.forName("database2project.Reviews"));
            Reviews newReview = new Reviews(this.reviewId, this.productId, this.customerId, this.score, 0,
                    this.description);
            String sql = "{ call reviews_package.add_review(?)}";
            stmt = conn.prepareCall(sql);
            stmt.setObject(1, newReview);
            stmt.execute();
            System.out.println("Successfully added review to the database");
        }
        catch (Exception e){
            System.out.println("Unable to add given review");
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

    public static void deleteReview(Connection conn, int review_id){
        String sql = "{ call reviews_package.delete_review(?)}";
        CallableStatement stmt = null;
        try{
        stmt = conn.prepareCall(sql);
        stmt.setInt(1, review_id);
        stmt.execute();
        System.out.println("Removed review with id: " + review_id + " from the database");
        }
        catch (SQLException e){
            System.out.println("Unable to delete review " + review_id);
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
    
    public static Reviews getReview(Connection conn, int review_id) {
        String sql = "{ ? = call reviews_package.get_review(?)}";
        Reviews foundReview = null;
        CallableStatement stmt = null;
        try {
            // Couldn't get it working without mapping so added
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put(Reviews.TYPENAME,
                    Class.forName("database2project.Reviews"));
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.STRUCT, "REVIEWS_TYP");
            stmt.setInt(2, review_id);
            stmt.execute();
            foundReview = (Reviews) stmt.getObject(1);
            return foundReview;
        } catch (Exception e) {
            System.out.println("Unable to get review " + review_id);
            // Will return a null found order if an error occurs
            return foundReview;
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
}
