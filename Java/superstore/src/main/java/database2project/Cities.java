package database2project;

public class Cities {

    //Private fields for all fields of the Cities table
    private int cityId;
    private String city;
    private String province;

    //Getters for the private field
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
}
