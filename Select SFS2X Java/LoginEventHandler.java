
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.smartfoxserver.bitswarm.sessions.ISession;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.db.IDBManager;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.exceptions.SFSErrorCode;
import com.smartfoxserver.v2.exceptions.SFSErrorData;
import com.smartfoxserver.v2.exceptions.SFSException;
import com.smartfoxserver.v2.exceptions.SFSLoginException;
import com.smartfoxserver.v2.extensions.BaseServerEventHandler;
import com.smartfoxserver.v2.security.DefaultPermissionProfile;
import com.smartfoxserver.v2.util.CryptoUtils;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

public class LoginEventHandler extends BaseServerEventHandler {

    @Override
    public void handleServerEvent(ISFSEvent event) throws SFSException {
        IDBManager dbManager = getParentExtension().getParentZone().getDBManager();
        
        // Grab parameters from client request
        String userName = (String) event.getParameter(SFSEventParam.LOGIN_NAME);
        String cryptedPass = (String) event.getParameter(SFSEventParam.LOGIN_PASSWORD); // NOTE: This really isn't needed.  We can remove this later.
        ISession session = (ISession) event.getParameter(SFSEventParam.SESSION); // NOTE: Might want to use this in the RSA.

        // Get password from additional data passed from the login request.
        ISFSObject params = (ISFSObject) event.getParameter(SFSEventParam.LOGIN_IN_DATA);

        String mode = params.getUtfString("mode");

        if (mode != null) {
            if (mode.equals("register")) {
                
                String username = params.getUtfString("username");
                String email = params.getUtfString("email");
                String email_confirm = params.getUtfString("email_confirm");
                String new_password = params.getUtfString("new_password");
                String password_confirm = params.getUtfString("password_confirm");

                try {
                    // Construct data
                    String data = URLEncoder.encode("username", "UTF-8") + "=" + URLEncoder.encode(username, "UTF-8");
                    data += "&" + URLEncoder.encode("email", "UTF-8") + "=" + URLEncoder.encode(email, "UTF-8");
                    data += "&" + URLEncoder.encode("email_confirm", "UTF-8") + "=" + URLEncoder.encode(email_confirm, "UTF-8");
                    data += "&" + URLEncoder.encode("new_password", "UTF-8") + "=" + URLEncoder.encode(new_password, "UTF-8");
                    data += "&" + URLEncoder.encode("password_confirm", "UTF-8") + "=" + URLEncoder.encode(password_confirm, "UTF-8");
                    data += "&" + URLEncoder.encode("submit", "UTF-8") + "=" + URLEncoder.encode("true", "UTF-8");
                    // NOTE: Would recommend having a "from_smartfox" verification string.
                    // This would prevent the Registration script from being accessed outside of our SmartFox extensions.


                    // Send data
                    // NOTE: Should pass user IP as well to let phpBB check for brute force attacks.  Until then login attempts is set to unlimited.
                    // NOTE: This could be a PHP shell command instead of a URL request.  Could be more efficient but would need to be tested.  Doubt it would make much difference though.
                    URL url = new URL("http://underverseonline.com/sfs-phpBB_registration.php"); // Custom script accesses phpBB login auth and language dictionary.
                    URLConnection conn = url.openConnection();
                    conn.setDoOutput(true);
                    OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
                    wr.write(data);
                    wr.flush();

                    // Get the response
                    BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    String output = "";
                    String line;
                    while ((line = rd.readLine()) != null) {
                        output = output + line;
                    }
                    trace("output: " + output);
                    wr.close();
                    rd.close();
                    
                    //prepopulate user_deities (Brent: Need your help getting the proper user_id after a registration is confirmed
                    //dbManager.executeUpdate("INSERT INTO "+UVShell.UV_DB+"uv_user_deities (user_id, deity_id, trinket_1, trinket_2, landmass_id) VALUES (56, 1, 1, 2, 4)"); // Xnooru
                    //dbManager.executeUpdate("INSERT INTO "+UVShell.UV_DB+"uv_user_deities (user_id, deity_id, trinket_1, trinket_2, landmass_id) VALUES (56, 2, 1, 2, 3)"); // Muphyro
                    //dbManager.executeUpdate("INSERT INTO "+UVShell.UV_DB+"uv_user_deities (user_id, deity_id, trinket_1, trinket_2, landmass_id) VALUES (56, 3, 1, 2, 1)"); // Lylandra
                    
                    if (output == "") {
                        trace("Registration error....this shouldn't happen!");
                        
                    } else {
                        trace("Registration processed!");

                        throw new SFSLoginException(output);
                    }

                } catch (Exception e) {
                    SFSErrorData errData = new SFSErrorData(SFSErrorCode.GENERIC_ERROR);
                    errData.addParameter(e.getMessage());
                    trace(e.getMessage());

                    throw new SFSLoginException(e.getMessage(), errData);
                }
            } else if (mode.equals("guest")) {
                
                // Pass no exceptions to login using SmartFox's guest system.
                session.setProperty("$permission", DefaultPermissionProfile.GUEST);
                session.setProperty(UVShell.DATABASE_ID, "1"); 
                // TEMP SOLUTION: Sets ID to 1 which is the guest account on phpBB to prevent SQL errors for now.
                
            }

        } else {

            String userPass = params.getUtfString("password"); // NOTE: Will be RSA that we will decrypt with our private key.  Plain text right now for testing.


            try {
                
                // Construct data
                String data = URLEncoder.encode("username", "UTF-8") + "=" + URLEncoder.encode(userName, "UTF-8");
                data += "&" + URLEncoder.encode("password", "UTF-8") + "=" + URLEncoder.encode(userPass, "UTF-8");

                // Send data
                // NOTE: Should pass user IP as well to let phpBB check for brute force attacks.  Until then login attempts is set to unlimited.
                URL url = new URL("http://underverseonline.com/sfs-phpBB_login.php"); // Custom script accesses phpBB login auth and language dictionary.
                URLConnection conn = url.openConnection();
                conn.setDoOutput(true);
                OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
                wr.write(data);
                wr.flush();

                // Get the response
                BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String output = "";
                String line;
                while ((line = rd.readLine()) != null) {
                    output = output + line;
                }
                wr.close();
                rd.close();

                if (isStringNumber(output)) {
                    trace("Login success!");
                    trace("User ID: "+ output);
                    
                    session.setProperty("$permission", DefaultPermissionProfile.STANDARD);
                    session.setProperty(UVShell.DATABASE_ID, output);
                    
                } else {
                    trace("Login failed!");

                    throw new SFSLoginException(output);
                }

            } catch (Exception e) {
                SFSErrorData errData = new SFSErrorData(SFSErrorCode.GENERIC_ERROR);
                errData.addParameter(e.getMessage());
                trace("LOGIN ERROR:"+e.getMessage());

                throw new SFSLoginException(e.getMessage(), errData);
            }

        }

    }
    
    public boolean isStringNumber(String num) {
        try {
            Integer.parseInt(num);
        } catch (NumberFormatException nfe) {
            return false;
        }
        return true;
    }
}