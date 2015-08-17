import com.smartfoxserver.v2.db.IDBManager;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;
import java.sql.SQLException;
import java.util.List;
import java.util.Arrays;

public class GetUserData extends BaseClientRequestHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        trace("Getting user data for user ID " + sender.getVariable("user_id").getStringValue());
        
        IDBManager dbManager = getParentExtension().getParentZone().getDBManager();
        String sql = "SELECT username,user_essence,user_last_deity_id,user_exp,user_elo,user_indie_tokens,user_wins,user_losses,user_avatar FROM "+UVShell.UV_DB+"phpbb_users WHERE user_id=" + sender.getVariable("user_id").getStringValue();
        
        try {
            // Obtain a resultset
            ISFSArray res = dbManager.executeQuery(sql);
            
            //trace(res.getDump());

            // Populate the response parameters
            ISFSObject response = new SFSObject();
            response.putSFSArray("user_data", res);
            
            // validate data
            if(!sender.getVariable("user_id").getStringValue().equals("1")){ // not a guest value of 1
                validateData(dbManager, sender, response);
            } else {
                // is guest - send default data
                response.putBool("isGuest", true);
                send("getUserData", response, sender);
            }


        } catch (SQLException e) {
            trace(ExtensionLogLevel.WARN, "SQL Failed: " + e.toString());
        }
        
    }
    
    private void validateData(IDBManager $dbManager, User $sender, ISFSObject $response){
        ISFSObject data = $response.getSFSArray("user_data").getSFSObject(0);
        
        if(data.getInt("user_last_deity_id") == 0){
            trace("No default deity found - creating one");
            // has no value, prepopulate with 1st entry
            try{
               ISFSArray res = $dbManager.executeQuery("SELECT id FROM "+UVShell.UV_DB+"uv_user_deities WHERE user_id="+$sender.getVariable("user_id").getStringValue()+" LIMIT 1");
               int user_last_deity_id = res.getSFSObject(0).getInt("id");
               
               $dbManager.executeUpdate("UPDATE "+UVShell.UV_DB+"phpbb_users SET user_last_deity_id = "+user_last_deity_id+" WHERE user_id="+$sender.getVariable("user_id").getStringValue());
               
               trace("using a new default last_deity_id:"+user_last_deity_id);
               
               $response.getSFSArray("user_data").getSFSObject(0).putInt("user_last_deity_id", user_last_deity_id);
               
            } catch(SQLException e){
                trace(ExtensionLogLevel.WARN, "SQL Failed: " + e.toString());
            }
        }
        
        UserVariable deity = new SFSUserVariable("user_deity", $response.getSFSArray("user_data").getSFSObject(0).getInt("user_last_deity_id"));
        List<UserVariable> vars = Arrays.asList(deity);
        getApi().setUserVariables($sender, vars);
        
        // assign the deity variable to the user in SFS
        
        trace("User data validated!");
        send("getUserData", $response, $sender);
    }
}
