
import java.sql.SQLException;

import com.smartfoxserver.v2.db.IDBManager;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;

public class GetAttributeVars extends BaseClientRequestHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        IDBManager dbManager = getParentExtension().getParentZone().getDBManager();
        String sql = "SELECT column_name, column_default FROM information_schema.columns WHERE NOT column_name =  'id' AND table_name =  'inventory'";

        try {
            ISFSArray res = dbManager.executeQuery(sql);

            ISFSObject response = new SFSObject();
            response.putSFSArray("attrVars", res);

            send("getAttributeVars", response, sender);
        } catch (SQLException e) {
            trace(ExtensionLogLevel.WARN, "SQL Failed: " + e.toString());
        }
    }
}