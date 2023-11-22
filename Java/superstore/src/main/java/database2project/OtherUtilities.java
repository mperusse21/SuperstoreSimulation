package database2project;
import java.sql.*;

/* Contains all methods for searching the database/validation, like getting flagged customers/average review score 
or validating an order */
public class OtherUtilities {


    public static void getFlaggedCustomers (Connection conn){
        String sql = "{ ? = call reviews_package.get_flagged_customers()}";
        CallableStatement stmt = null;
        Array results = null;
        int[] resultInts;
        try {
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.ARRAY, "CUSTOMER_ID_VARRAY");
            stmt.execute();
            results = stmt.getArray(1);
            resultInts = (int[])results.getArray();
            for (int num : resultInts){
                System.out.println(num);
            }
        }
        catch (SQLException e){
            e.printStackTrace();
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
