package database2project;
import java.sql.*;

public class SuperStoreServices {
    private String url = "jdbc:oracle:thin:@198.168.52.211:1521/pdbora19c.dawsoncollege.qc.ca";
    private Connection conn;
    
    //Constructor which takes username and password and creates a connection 
    // (Exceptions will be handled in the application)
    public SuperStoreServices (String user, String password) throws SQLException{
        this.conn = DriverManager.getConnection(url, user, password);
        System.out.println("Connected");
    }

    // Method which closes the connection
    public void close () throws SQLException{
        conn.close();
        System.out.println("Disconnected");
    }

    public Connection retrievConnection (){
        return this.conn;
    }

    // Potentially put various methods like add in here as well
}

