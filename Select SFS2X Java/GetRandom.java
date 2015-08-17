
import java.util.Random;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.*;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.SmartFoxServer;

public class GetRandom extends BaseClientRequestHandler {

    Random rand = new Random();
    private long seed = rand.nextInt(1000000);

    @Override
    public void handleClientRequest(User $sender, ISFSObject $params) {

        ISFSObject response = new SFSObject();
        response.putLong("seed", seed);
        
        ISFSArray exampleArray = new SFSArray();
        
        for(int i=0; i<10; i++){
            exampleArray.addDouble(getRandom());
        }
        
        response.putSFSArray("example", exampleArray);
        
        send("getRandom", response, $sender);

    }

    private double getRandom() {
        seed = (seed * 9301 + 49297) % 233280;
        return seed / (233280.0);
    }
}
