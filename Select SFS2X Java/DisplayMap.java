import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.*;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.db.IDBManager;
import com.smartfoxserver.v2.SmartFoxServer;
import java.sql.SQLException;

//import java.util.ArrayList;

public class DisplayMap extends BaseClientRequestHandler
{
    private IDBManager _dbManager = SmartFoxServer.getInstance().getZoneManager().getZoneByName(UVShell.ZONE).getDBManager();

    @Override
    public void handleClientRequest(User $sender, ISFSObject $params){

        ISFSObject resObj = SFSObject.newInstance(); // response object (to be sent to client)

        ISFSArray maps = new SFSArray();

        String SQL;


        // EVENTUALLY UPDATE THIS SO IT DOESNT POLL THE DB SO MUCH!

        // get maps that are equal to type in $params
        SQL = "SELECT * FROM "+UVShell.UV_DB+"uv_maps WHERE name = '"+$params.getUtfString("mapName")+"';";
        trace("SQL:"+SQL);
        try{
            maps = _dbManager.executeQuery(SQL);
        } catch (SQLException ex) {
            trace("ERROR IN SQL");
        }

        if(maps != null || maps.size() > 0){
            resObj.putSFSArray("maps", maps);
        } else {
            resObj.putNull("maps");
        }

        send("displayMap", resObj, $sender);
    }
}
