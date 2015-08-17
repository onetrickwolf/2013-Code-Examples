
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.*;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.db.IDBManager;
import com.smartfoxserver.v2.SmartFoxServer;
import java.sql.SQLException;

public class RegisterHandler extends BaseClientRequestHandler
{

    // Obtain the DBManager and reference the zone name specified in UVShell.ZONE
    private IDBManager _dbManager = SmartFoxServer.getInstance().getZoneManager().getZoneByName(UVShell.ZONE).getDBManager();

    @Override
    public void handleClientRequest(User $sender, ISFSObject $params)
    {
        boolean success = true;
        String failReason = "";

        String fName = $params.getUtfString("fName");
        String lName = $params.getUtfString("lName");
        String email = $params.getUtfString("email");
        String password = $params.getUtfString("password");
        
        ISFSObject resObj = SFSObject.newInstance();

        if(DuplicateEmail(email) == false){
            // Add new user to Database (default access at 0)
            String SQL = "INSERT INTO USERS VALUES(null, '" + email + "', '" + password + "', 0, '" + fName + "', '" + lName + "', 0)";
            try{
                _dbManager.executeUpdate(SQL);
            } catch (SQLException ex) {
                trace(" NEW XXXXXXXXXXX ");
            }
            // If successful, send success response
            resObj.putBool("success", true); 
        } else {
            // If Duplicate email is found, send a response saying that User already exists!
            resObj.putBool("success", false);
            resObj.putUtfString("reason", "User Already Exists!");
        }

        send("register", resObj, $sender);  
    }

    private boolean DuplicateEmail(String $email){
        ISFSArray emailResult = null;
        String SQL = "SELECT * FROM USERS WHERE EMAIL='" + $email + "' LIMIT 1;";
        // Execute SQL query
        try {
            emailResult = (ISFSArray) _dbManager.executeQuery(SQL);
        } catch (SQLException ex) {
            trace(" EMAIL CHECK XXXXXXX ");
        }
        // check to see if a result is returned, if so, return true
        if(emailResult.size() >= 1){
            return true;
        } else {
            return false;
        }
    }
}
