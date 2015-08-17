import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.*;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.db.IDBManager;
import com.smartfoxserver.v2.SmartFoxServer;
import java.sql.SQLException;
import java.util.Collection;
import java.util.List;
import java.util.Arrays;

public class GetPowers extends BaseClientRequestHandler{

    private IDBManager _dbManager = SmartFoxServer.getInstance().getZoneManager().getZoneByName(UVShell.ZONE).getDBManager();

    @Override
    public void handleClientRequest(User $sender, ISFSObject $params){

        ISFSObject resObj = SFSObject.newInstance(); // response object (to be sent to client)
        ISFSArray powersArray = new SFSArray();
        ISFSArray trinketsArray = new SFSArray();

        Collection<String> str = $params.getUtfStringArray("powers");
        String[] powers = ((List<String>) str).toArray(new String[str.size()]);
        
        Collection<String> strt = $params.getUtfStringArray("trinkets");
        String[] trinkets = ((List<String>) strt).toArray(new String[strt.size()]);

        //trace("POWERS: "+Arrays.toString( powers ));
        //trace("TRINKETS: "+Arrays.toString( trinkets ));

        String powersString = implodeArray(powers,",");
        String trinketsString = implodeArray(trinkets,",");

        //trace("POWERSSTRING: "+powersString);

        String SQL = "SELECT * FROM "+UVShell.UV_DB+"uv_powers WHERE name IN ("+powersString+") ORDER BY FIELD(name,"+powersString+");";

        try{
            powersArray = _dbManager.executeQuery(SQL);
        } catch (SQLException ex) {
            trace("ERROR IN SQL");
        }
        
        String SQL2 = "SELECT * FROM "+UVShell.UV_DB+"uv_powers WHERE name IN ("+trinketsString+") ORDER BY FIELD(name,"+trinketsString+");";

        try{
            trinketsArray = _dbManager.executeQuery(SQL2);
        } catch (SQLException ex) {
            trace("ERROR IN SQL");
        }

        resObj.putSFSArray("powers", powersArray);
        resObj.putSFSArray("trinkets", trinketsArray);

        send("getPowers", resObj, $sender);
    }

    public static String implodeArray(String[] inputArray, String glueString) {

        /** Output variable */
        String output = "";

        if (inputArray.length > 0) {
            StringBuilder sb = new StringBuilder();
            sb.append("'");
            sb.append(inputArray[0]);
            sb.append("'");

            for (int i=1; i<inputArray.length; i++) {
                sb.append(glueString);
                sb.append("'");
                sb.append(inputArray[i]);
                sb.append("'");
            }

            output = sb.toString();
        }

        return output;
    }

}