package
{
	import com.smartfoxserver.v2.SmartFox
	import com.smartfoxserver.v2.core.SFSEvent
	import com.smartfoxserver.v2.entities.*
	import com.smartfoxserver.v2.entities.data.*
	import com.smartfoxserver.v2.entities.match.*
	import com.smartfoxserver.v2.entities.variables.*
	import com.smartfoxserver.v2.entities.invitation.*
	import com.smartfoxserver.v2.requests.*
	import com.smartfoxserver.v2.requests.game.*
	import com.smartfoxserver.v2.logging.*
	
	import flash.display.*
	import flash.events.*
	import flash.system.Security
	
	public class RegisterExample extends Sprite
	{	
		private var sfs:SmartFox
		private var autoJoin:Boolean = false
		
		public function RegisterExample()
		{
		 	sfs = new SmartFox()
			sfs.debug = true
			
			sfs.addEventListener(SFSEvent.CONNECTION, onConnection)
			sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost)
			
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoadSuccess)
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailure)
			
			sfs.addEventListener(SFSEvent.LOGIN, onLogin)
			sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError)
			
			sfs.addEventListener(SFSEvent.ROOM_JOIN, onJoin)
			sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onJoinError)
			
			bt_connect.addEventListener(MouseEvent.CLICK, onBtConnectClick)
			
			bt_register.addEventListener(MouseEvent.CLICK, onBtLoginClick)
			
			dTrace("SmartFox API: "+ sfs.version)
			dTrace("Click CONNECT to start...")
			
		}	
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Button Handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function onBtConnectClick(evt:Event):void
		{
			sfs.loadConfig("sfs-config-brent-server.xml")
		}

		private function onBtLoginClick(evt:Event):void
		{
			//Since you can't send extension requests without logging in, we're going to let users register through a special LoginRequest.
			var registerObj:SFSObject = new SFSObject(); //Passed in plain text for testing.  Will eventually pass as RSA encrypted with public key.
			registerObj.putUtfString("mode", "register");
    		registerObj.putUtfString("username", ti_username.text); 
			registerObj.putUtfString("email", ti_email.text);
			registerObj.putUtfString("email_confirm", ti_email_confirm.text);
			registerObj.putUtfString("new_password", ti_new_password.text);
			registerObj.putUtfString("password_confirm", ti_password_confirm.text);
			
			sfs.send(new LoginRequest("register_request", "register_request", sfs.config.zone, registerObj));
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Event Handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function onConnection(evt:SFSEvent):void
		{
			//ta_debug.text = ""
			if (evt.params.success)
			{
				dTrace("Connection Success!")
				bt_register.enabled = true;
			}
			else
			{
				dTrace("Connection Failure: " + evt.params.errorMessage)
			}
		}
		
		private function onConnectionLost(evt:SFSEvent):void
		{
			dTrace("Connection was lost. Reason: " + evt.params.reason)
		}

		private function onLogin(evt:SFSEvent):void
		{
			dTrace("Logged in as: " + evt.params.user.name)
		}
		
		private function onLoginError(evt:SFSEvent):void
		{
			if(evt.params.errorMessage.indexOf("|") >= 0){
				dTrace("Registration failed: " + evt.params.errorMessage)
			} else {
				dTrace("Registration Success!: " + evt.params.errorMessage)
			}
		}
		
		private function onJoin(evt:SFSEvent):void
		{
			dTrace("Joined in Room: " + evt.params.room.name)
			dTrace("Avatar Image: " + sfs.mySelf.getVariable("avatar").getStringValue())
		}
		
		private function onJoinError(evt:SFSEvent):void
		{
			dTrace("Room Join error: " + evt.params.errorMessage)
		}

		private function onConfigLoadSuccess(evt:SFSEvent):void
		{
			dTrace("Config load success!")
			dTrace("Server settings: "  + sfs.config.host + ":" + sfs.config.port)
		}
		
		private function onConfigLoadFailure(evt:SFSEvent):void
		{
			dTrace("Config load failure!!!")
		}

		private function dTrace(msg:String):void
		{
			ta_debug.text += "--> " + msg + "\n";
		}
		
	}
}
