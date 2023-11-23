package database2project;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.*;

public class Stores {

    //Private fields for all fields of the Stores table
    public int storeId;
    public String storeName;

    //Getters for the private fields
    public int getStoreId(){
        return this.storeId;
    }
    public String getStoreName(){
        return this.storeName;
    }

    //Constructor initializing all private fields
    public Stores(int storeId, String storeName){
        this.storeId = storeId;
        this.storeName = storeName;
    }

    public String toString(){
        return "| Stored ID: " + this.storeId + " | Store Name: " + this.storeName;
    }

      public static String getStore (Connection conn, int storeId) throws SQLException, ClassNotFoundException {
        String sql = "{ ? = call stores_package.getStore(?)}";
        String foundStore = null;
        try (CallableStatement stmt = conn.prepareCall(sql)){

            stmt.registerOutParameter(1, Types.VARCHAR);
            stmt.setInt(2, storeId);
            stmt.execute();
            foundStore = stmt.getString(1);
            return foundStore;
        }

    }
    
}
