import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class ItemExtension extends SFSExtension
{
    public static String ZONE = "Underverse";

    @Override
    public void init()
    {   
        trace("UV SHELL EXTENSION INITIATED");
        addRequestHandler("getAttributeVars", GetAttributeVars.class);
    }
}