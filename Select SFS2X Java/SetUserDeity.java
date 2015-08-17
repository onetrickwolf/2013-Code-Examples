
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import java.util.Arrays;
import java.util.List;

public class SetUserDeity extends BaseClientRequestHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        trace(params.getInt("deity_id"));
        Integer deityID = params.getInt("deity_id");

            UserVariable deity = new SFSUserVariable("selected_deity", deityID);
            List<UserVariable> vars = Arrays.asList(deity);
            getApi().setUserVariables(sender, vars);
            
            ISFSObject response = new SFSObject();
            response.putUtfString("deity_set_message", "Deity set to "+deityID);
            
            send("setUserDeity", response, sender);
            
            // A databse update should go here to update the user's active deity as well.
            // This will save their active deity for the future.

    }
}
