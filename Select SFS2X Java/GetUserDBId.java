
import com.smartfoxserver.v2.entities.*;
import com.smartfoxserver.v2.db.IDBManager;
import com.smartfoxserver.v2.SmartFoxServer;
import java.sql.SQLException;

public class GetUserDBId {
    private static IDBManager _dbManager = SmartFoxServer.getInstance().getZoneManager().getZoneByName(UVShell.ZONE).getDBManager();

    public void GetUserDBId(){
        
    }

    public static long getID(User $user){
        long dbID = 0;
        String SQL = "SELECT ID FROM "+UVShell.UV_DB+"USERS WHERE EMAIL='" + $user.getName() + "' LIMIT 1;";
        try{
            dbID = _dbManager.executeQuery(SQL).getSFSObject(0).getLong("ID");
        } catch (SQLException ex) {
            // error: ID error
        }
        return dbID;
    }
}
