package database2project;

import java.sql.*;
import java.util.List;
import java.util.Scanner;
public class MitchTests 
{
    public static void main( String[] args ) throws ClassNotFoundException{
        Scanner reader = new Scanner(System.in);
        SuperStoreServices connection = null;
        boolean validLogin = false;
        while (!validLogin){
        try {
            // Prompt user for username and password
            System.out.print("Enter your username: ");
            String user = reader.next();
            String password = new String(System.console().readPassword("Password: "));

            // Creating the connection using the SuperStoreServices object
            connection = new SuperStoreServices(user, password);
            validLogin = true;

            System.out.println(connection.getAverageScore(2));
        }
        
        // Catches any possible exceptions
        catch (SQLException e){
            System.out.println("Invalid username or password");
        }   

        // Closes the connection and the Scanner
        finally {
            try{
                if (connection != null) {
                    connection.close();
                }
            }
            catch (SQLException e){
                e.printStackTrace();
            }
        }
    }

    reader.close();

    }
}
