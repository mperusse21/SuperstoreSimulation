package database2project;

import java.sql.*;
public class App {
    public static void main( String[] args ) {
     
    }

    public static Connection getConnection() throws SQLException {
    String user = System.console().readLine("Username: ");
    String password = new String(System.console().readPassword("Password: "));
    String url = "jdbc:oracle:thin:@198.168.52.211:1521/pdbora19c.dawsoncollege.qc.ca";
    return DriverManager.getConnection(url, user, password);
    }

}
