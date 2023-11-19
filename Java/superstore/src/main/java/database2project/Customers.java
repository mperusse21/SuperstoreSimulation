package database2project;

public class Customers {

    //Private fields for all fields of the Customers table
    private int customerId;
    private String firstname;
    private String lastname;
    private String email;
    private int addressId;
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

    //Constructor initializing all private fields
    public Customers(int customerId, String firstname, String lastname, String email, int addressId){
        this.customerId = customerId;
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.addressId = addressId;
    }

}
