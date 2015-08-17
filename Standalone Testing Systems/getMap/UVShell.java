
import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class UVShell extends SFSExtension
{
    public static String ZONE = "Underverse";

    @Override
    public void init()
    {
        trace("UV SHELL EXTENSION INITIATED");

        // Add a new Request Handler
        addEventHandler(SFSEventType.USER_LOGIN, LoginEventHandler.class);
        //addEventHandler(SFSEventType.USER_JOIN_ZONE, JoinEventHandler.class);
        addRequestHandler("register", RegisterHandler.class);
        addRequestHandler("getCharacters", CharacterHandler.class);
        addRequestHandler("createCharacter", CreateCharacter.class);

        //addRequestHandler("createGame", CreateGame.class);

        addRequestHandler("getLandmasses", LandMassesHandler.class);
        //addRequestHandler("quickMatch", FindQuickMatch.class);
        //addRequestHandler("getCharacter", GetCharacters.class);
        
        addRequestHandler("getMap", GetMap.class);
    }
}