package database2project;

import java.sql.*;
import java.util.Map;

public class Customers implements SQLData {

    //Private fields for all fields of the Customers table
    private int customerId;
    private String firstname;
    private String lastname;
    private String email;
    private int addressId;
    public static final String TYPENAME = "CUSTOMERS_TYPE";
    //Optional private field (may not be used)
    private Addresses address;

    //Getters for the private fields
    public int getCustomerId(){
        return this.customerId;
    }
    public String getFirstname(){
        return this.firstname;
    }
    public String getLastname(){
        return this.lastname;
    }
    public String getEmail(){
        return this.email;
    }
    public int getAddressId(){
        return this.addressId;
    }
    //Optional
    public Addresses getAddress(){
        return this.address;
    }

    //Setters for the private fields
    public void setCustomerId(int customerId){
        this.customerId = customerId;
    }
    public void setFirstname(String firstname){
        this.firstname = firstname;
    }
    public void setLastname(String lastname){
        this.lastname = lastname;
    }
    public void setEmail(String email){
        this.email = email;
    }
    public void setAddressId(int addressId){
        this.addressId = addressId;
    }
    public void setAddress(Addresses address){
        this.address = address;
    }

    //Constructor initializing all private fields
    public Customers(int customerId, String firstname, String lastname, String email, int addressId){
        this.customerId = customerId;
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.addressId = addressId;
    }

    @Override
    public String getSQLTypeName() throws SQLException {
        return Customers.TYPENAME;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        setCustomerId(stream.readInt());
        setFirstname(stream.readString());
        setLastname(stream.readString());
        setEmail(stream.readString());
        setAddressId(stream.readInt());
        //setAddress();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(getCustomerId());
        stream.writeString(getFirstname());
        stream.writeString(getLastname());
        stream.writeString(getEmail());
        stream.writeInt(getAddressId());
    }

    //toString for Customers
    @Override
    public String toString(){
        return "| Customer Id: " + this.customerId + " | Fullname: " + this.firstname + " " + this.lastname + " | Email: " + this.email + " | Address Id: " + this.addressId;
    }


    //empty constructor to be used for getCustomerByEmail
    public Customers (){};

    public static Customers getCustomerByEmail (Connection conn, String email) throws SQLException, ClassNotFoundException {
        String sql = "{ ? = call customers_package.getCustomerByEmail(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)){

            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put(Customers.TYPENAME, Class.forName("database2project.Customers"));
            stmt.registerOutParameter(1, Types.STRUCT, "CUSTOMERS_TYPE");
            stmt.setString(2, email);
            stmt.execute();
            Customers foundCustomer = (Customers)stmt.getObject(1);
            return foundCustomer;
        }

    }

    public static Customers getCustomerById (Connection conn, int customerId) throws SQLException, ClassNotFoundException {
        String sql = "{ ? = call customers_package.getCustomer(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)){

            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put(Customers.TYPENAME, Class.forName("database2project.Customers"));
            stmt.registerOutParameter(1, Types.STRUCT, "CUSTOMERS_TYPE");
            stmt.setInt(2, customerId);
            stmt.execute();
            Customers foundCustomer = (Customers)stmt.getObject(1);
            return foundCustomer;
        }

    }



}
