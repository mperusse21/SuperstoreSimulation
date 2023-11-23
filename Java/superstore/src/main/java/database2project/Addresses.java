package database2project;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.*;

public class Addresses {

    //Private fields for all fields of the Addresses table
    private int addressId;
    private String address;
    private int cityId;
    //Optional private field (may not be used)
    private Cities city;

    //Getters for the private fields
    public int getAddressId(){
        return this.addressId;
    }
    public String getAddress(){
        return this.address;
    }
    public int getCityId(){
        return this.cityId;
    }
    //Optional
    public Cities getCity(){
        return this.city;
    }

    //Constructor initializing all private fields
    public Addresses(int addressId, String address, int cityId){
        this.addressId = addressId;
        this.address = address;
        this.cityId = cityId;
    }

    public static String getAddress (Connection conn, int addressId) throws SQLException, ClassNotFoundException {
        String sql = "{ ? = call addresses_package.getAddress(?)}";
        String foundAddress = null;
        try (CallableStatement stmt = conn.prepareCall(sql)){

            stmt.registerOutParameter(1, Types.VARCHAR);
            stmt.setInt(2, addressId);
            stmt.execute();
            foundAddress = stmt.getString(1);
            return foundAddress;
        }

    }

    public static int getCityId (Connection conn, String address) throws SQLException, ClassNotFoundException {
        String sql = "{ ? = call addresses_package.getCityId(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)){

            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.setString(2, address);
            stmt.execute();
            int foundCityId = stmt.getInt(1);
            return foundCityId;
        }

    }
    
    
}
