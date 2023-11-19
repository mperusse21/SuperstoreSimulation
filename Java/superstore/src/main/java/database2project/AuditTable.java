package database2project;

public class AuditTable {

    //Private fields for all fields of the AuditTable table
    private int auditId;
    private int changedId;
    private String action;
    private String tableChanged;

    //Getters for the private fields
    public int getAuditId(){
        return this.auditId;
    }
    public int getChangedId(){
        return this.changedId;
    }
    public String getAction(){
        return this.action;
    }
    public String getTableChanged(){
        return this.tableChanged;
    }

    //Constructor initializing all private fields
    public AuditTable(int auditId, int changedId, String action, String tableChanged){
        this.auditId = auditId;
        this.changedId = changedId;
        this.action = action;
        this.tableChanged = tableChanged;
    }
}
