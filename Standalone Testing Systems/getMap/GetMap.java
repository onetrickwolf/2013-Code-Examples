
import java.sql.SQLException;

import com.smartfoxserver.v2.db.IDBManager;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;

import java.util.Arrays;
import java.util.List;

public class GetMap extends BaseClientRequestHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        IDBManager dbManager = getParentExtension().getParentZone().getDBManager();
        String sql = "SELECT * FROM maps";

        try {
            // Obtain a resultset
            ISFSArray res = dbManager.executeQuery(sql);
            ISFSObject item = res.getSFSObject(0);
            
            String mapString = item.getUtfString("MAP_DATA");
            String delims = "[?]";
            String[] tokens = mapString.split(delims);
            List parsedMap = Arrays.asList(tokens);
            
            // Populate the response parameters
            ISFSObject response = new SFSObject();
            response.putSFSArray("maps", res);
            response.putUtfStringArray("parsedMap", parsedMap);

            // Send back to requester
            send("getMap", response, sender);
        } catch (SQLException e) {
            trace(ExtensionLogLevel.WARN, "SQL Failed: " + e.toString());
        }
    }
}
