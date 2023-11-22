package database2project;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.*;

public class Cities {

    //Private fields for all fields of the Cities table
    private int cityId;
    private String city;
    private String province;

    //Getters for the private fields
    public int getCityId(){
        return this.cityId;
    }
    public String getCity(){
        return this.city;
    }
    public String getProvince(){
        return this.province;
    }
    
    //Constructor initializing all private fields
    public Cities (int cityId, String city, String province){
        this.cityId = cityId;
        this.city = city;
        this.province = province;

    }

    public static String getCity (Connection conn, int cityId) throws SQLException, ClassNotFoundException {
        String sql = "{ ? = call cities_package.getCity(?)}";
        String foundCity = null;
        try (CallableStatement stmt = conn.prepareCall(sql)){

            stmt.registerOutParameter(1, Types.VARCHAR);
            stmt.setInt(2, cityId);
            stmt.execute();
            foundCity = stmt.getString(1);
            return foundCity;
        }

    }
}
