package database2project;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Products implements SQLData {

    //Private fields for all fields of the Products table
    private int productId;
    private String productName;
    private String category; 
    //private String TYPENAME;
    public static final String TYPENAME = "PRODUCTS_TYPE";

    //Getters for the private fields
    public int getProductId(){
        return this.productId;
    }
    public String getProductName(){
        return this.productName;
    }
    public String getCategory(){
        return this.category;
    }

    //Setters for the private fields
    public void setProductId(int productId){
        this.productId = productId;
    }
    public void setProductName(String productName){
        this.productName = productName;
    }
    public void setCategory(String category){
        this.category = category;
    }
    
    //Constructor initializing all private fields
    public Products(int productId, String productName, String category){
        this.productId = productId;
        this.productName = productName;
        this.category = category;
    }

    @Override
    public String getSQLTypeName() throws SQLException {
        return Products.TYPENAME;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        setProductId(stream.readInt());
        setProductName(stream.readString());
        setCategory(stream.readString());
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(getProductId());
        stream.writeString(getProductName());
        stream.writeString(getCategory());
    }

    //toString for Products
    @Override 
    public String toString(){
        return "| Product Id: " + this.productId + " | Product Name: " + this.productName + " | Category: " + this.category + " |";
    }

    //empty constructor to be used for getProduct
    public Products (){};

    public static Products getProduct (Connection conn, int product_id) throws SQLException, ClassNotFoundException {
        String sql = "{ ? = call products_package.getProduct(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)){

            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put(Products.TYPENAME, Class.forName("database2project.Products"));
            stmt.registerOutParameter(1, Types.STRUCT, "PRODUCTS_TYPE");
            stmt.setInt(2, product_id);
            stmt.execute();
            Products foundproduct = (Products)stmt.getObject(1);
            return foundproduct;
        }

    }

    public static List<Products> getProductsByCategory(Connection conn, String category) {
        String sql = "{ call ? := products_package.getAllProductsByCategory(?) }";
        CallableStatement stmt = null;
        ResultSet results = null;
        List<Products> productList = new ArrayList<Products>();
        try{
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.setString(2, category);
            stmt.execute();
            results = (ResultSet) stmt.getObject(1);
            while (results.next()){
                Products foundProduct = new Products (results.getInt("ProductId"), results.getString("ProductName"), results.getString("Category")); 
                productList.add(foundProduct);
            }
        }

        catch (SQLException e){
            e.printStackTrace();
        }
        finally {
            try{
                if (!stmt.isClosed() && stmt != null){
                    stmt.close();
                }
            }
            catch (SQLException e) {
                e.printStackTrace();
            }
        }
           
              return productList;
    
        }

    public static List<Products> getAllProducts(Connection conn) {
        String sql = "{ call ? := products_package.getAllProducts() }";
        CallableStatement stmt = null;
        ResultSet results = null;
        List<Products> productList = new ArrayList<Products>();
        try{
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.execute();
            results = (ResultSet) stmt.getObject(1);
            while (results.next()){
                Products allProduct = new Products (results.getInt("ProductId"), results.getString("ProductName"), results.getString("Category")); 
                productList.add(allProduct);
            }
        }

        catch (SQLException e){
            e.printStackTrace();
        }
        finally {
            try{
                if (!stmt.isClosed() && stmt != null){
                    stmt.close();
                }
            }
            catch (SQLException e) {
                e.printStackTrace();
            }
        }
           
              return productList;
    
        }
    }


