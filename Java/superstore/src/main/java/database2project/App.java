package database2project;

import java.sql.*;
public class App {
    public static void main( String[] args ) {

    try {
        String user = System.console().readLine("Username: ");
        String password = new String(System.console().readPassword("Password: "));
        ProductsServices productServices = new ProductsServices(user, password);
        productServices.updateProduct(1,"Laptop", "Electronic");
    }

    catch (SQLException e){
        e.printStackTrace();
    }
    finally{

        try{
         productServices.close(); 
        }
        catch(SQLException e){
            e.printStackTrace();
            }
        }
    }

}
