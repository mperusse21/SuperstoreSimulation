package database2project;

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
    
    
}
