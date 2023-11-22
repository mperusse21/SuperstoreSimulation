package database2project;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
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

    @Override
    public String toString(){
        return "| Audit ID: " + this.auditId + " | ID of changed row: " + this.changedId + " | Action: " + this.action + " | Table Changed: " + this.tableChanged + " |";
    }

     public static List<AuditTable> getAuditTable(Connection conn) {
        String sql = "{ call ? := getAuditTable() }";
        CallableStatement stmt = null;
        ResultSet results = null;
        List<AuditTable> auditList = new ArrayList<AuditTable>();
        try{
            stmt = conn.prepareCall(sql);
            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.execute();
            results = (ResultSet) stmt.getObject(1);
            while (results.next()){
                AuditTable allAudit = new AuditTable(results.getInt("AuditId"), results.getInt("ChangedId"), results.getString("Action"), results.getString("TableChanged")); 
                auditList.add(allAudit);
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
           
              return auditList;
    
        }
}
