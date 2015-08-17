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
	
	public class LoginExample extends Sprite
	{	
		private var sfs:SmartFox
		private var autoJoin:Boolean = false
		
		public function LoginExample()
		{
		 	sfs = new SmartFox()
			sfs.debug = true
			
			sfs.addEventListener(SFSEvent.CONNECTION, onConnection)
			sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost)
			
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoadSuccess)
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailure)
			
			sfs.addEventListener(SFSEvent.LOGIN, onLogin)
			sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError)
			
			sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE,onExtensionResponse);
			
			sfs.addEventListener(SFSEvent.ROOM_ADD, onRoomCreated);
			sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoined);
			sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVarsUpdate);
			
			bt_connect.addEventListener(MouseEvent.CLICK, onBtConnectClick)
			
			bt_login.addEventListener(MouseEvent.CLICK, onBtLoginClick)
			bt_guest_login.addEventListener(MouseEvent.CLICK, onBtGuestLoginClick)
			bt_set_deity.addEventListener(MouseEvent.CLICK, onBtSetDeityClick)
			bt_create.addEventListener(MouseEvent.CLICK, onBtCreateClick)
			bt_join.addEventListener(MouseEvent.CLICK, onBtJoinClick)

			
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
			//LoginRequest hashes the user's password automatically.  We want to use RSA encryption so we'll be passing addtional parameters.
			var loginObj:SFSObject = new SFSObject();
    		loginObj.putUtfString("password", ti_pass.text); //Passed in plain text for testing.  Will eventually pass as RSA encrypted with public key.
			
			sfs.send(new LoginRequest(ti_name.text, ti_pass.text, sfs.config.zone, loginObj));
		}
		
		private function onBtGuestLoginClick(evt:Event):void
		{
			//LoginRequest hashes the user's password automatically.  We want to use RSA encryption so we'll be passing addtional parameters.
			var loginObj:SFSObject = new SFSObject();
			loginObj.putUtfString("mode", "guest");
			
			sfs.send(new LoginRequest("", "", sfs.config.zone, loginObj));
		}
	
		private function onBtSetDeityClick(evt:Event):void
		{
			var extObj:SFSObject = new SFSObject();
    		extObj.putInt("deity_id", int(ti_deity_id.text));
			sfs.send(new ExtensionRequest("setUserDeity", extObj));
			
		}

		private function onBtCreateClick(evt:Event):void
		{
			CreateRoom();
		}
		
		private function onBtJoinClick(evt:Event):void
		{
			sfs.send( new JoinRoomRequest("testroom"));
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
				bt_login.enabled = true;
				bt_guest_login.enabled = true;
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
			sfs.send(new ExtensionRequest("getUserData"));
			bt_set_deity.enabled = true;
			bt_create.enabled = true;
			bt_join.enabled = true;
		}
		
		private function onLoginError(evt:SFSEvent):void
		{
			dTrace("Login Failure: " + evt.params.errorMessage)
		}
		
		private function onExtensionResponse(evt:SFSEvent):void
		{
			var params:ISFSObject = evt.params.params as ISFSObject;
			if (evt.params.cmd == "getUserData")
			{
				var userDataArray:ISFSArray = params.getSFSArray("user_data");
				var userDataObject:ISFSObject = userDataArray.getSFSObject(0);
				
				var dump:String = "User Data: \n"
				+"user_indie_tokens: " + userDataObject.getInt("user_indie_tokens") + "\n"
				+"username: " + userDataObject.getUtfString("username") + "\n"
				+"user_essence: " + userDataObject.getInt("user_essence") + "\n"
				+"user_exp: " + userDataObject.getInt("user_exp") + "\n"
				+"user_wins: " + userDataObject.getInt("user_wins") + "\n"
				+"user_avatar: " + userDataObject.getUtfString("user_avatar") + "\n"
				+"user_losses: " + userDataObject.getInt("user_losses") + "\n"
				+"user_elo: " + userDataObject.getInt("user_elo");

				dTrace(dump);
			}
			else if (evt.params.cmd == "getUserDeities")
			{
				dTrace("Deities array receieved!");
			}
			else if (evt.params.cmd == "setUserDeity")
			{
				dTrace(params.getUtfString("deity_set_message"));
			}
			else if (evt.params.cmd == "getDeity")
			{
				var deityDataArray:ISFSArray = params.getSFSArray("deity_data");
				var deityDataObject:ISFSObject = deityDataArray.getSFSObject(0);
				
				dump = params.getUtfString("user_name")+"'s new deity data: \n"
				+"name: " + deityDataObject.getUtfString("name") + "\n"
				+"health: " + deityDataObject.getUtfString("health") + "\n"
				+"attack: " + deityDataObject.getUtfString("attack") + "\n"
				+"physical_defense: " + deityDataObject.getUtfString("physical_defense") + "\n"
				+"crit_chance: " + deityDataObject.getUtfString("crit_chance") + "\n"
				+"landmass_skin: " + deityDataObject.getUtfString("landmass_skin") + "\n"
				+"landmass_color: " + deityDataObject.getInt("landmass_color") + "\n"
				+"powers: " + deityDataObject.getUtfString("powers");
				
				dTrace(dump);
			}
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
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// 
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private static const EXTENSION_ID:String = "UVExtension";
		private static const EXTENSIONS_CLASS:String = "game.UVGame";
		
		private function CreateRoom($forceUnique:Boolean = false){
			var settings:SFSGameSettings;

			settings = new SFSGameSettings("testroom");
			
			//settings.groupId = "test";
			settings.extension = new RoomExtension(EXTENSION_ID, EXTENSIONS_CLASS);
			settings.maxUsers = 2;
			settings.maxSpectators = 0;
			settings.isPublic = true;
			settings.isGame = true;
			settings.leaveLastJoinedRoom = true;
			settings.minPlayersToStartGame = 2;
			
			var permissions:RoomPermissions = new RoomPermissions();
			permissions.allowNameChange = false;
			permissions.allowPasswordStateChange = true;
			permissions.allowPublicMessages = true;
			permissions.allowResizing = true;
			
			settings.permissions = permissions;
			
			sfs.send( new CreateSFSGameRequest(settings));
		}
		 
		 private function onRoomCreated(evt:SFSEvent):void
		 {
			 dTrace("Room created: " + evt.params.room);
		 }
		 
         private function onRoomJoined(evt:SFSEvent):void
         {
             dTrace("Room joined successfully: " + evt.params.room);
         }
		 
         private function onUserVarsUpdate(evt:SFSEvent):void
         {
             var changedVars:Array = evt.params.changedVars as Array;
             var user:User = evt.params.user as User;
             
             // Check if the user changed his x and y user variables
             if (changedVars.indexOf("selected_deity") != -1)
             {
                 dTrace(user.name + " has change his deity to " + user.getVariable("selected_deity").getIntValue())
             }
			var extObj:SFSObject = new SFSObject();
    		extObj.putInt("deity_id", user.getVariable("selected_deity").getIntValue());
			extObj.putUtfString("user_name", user.name);
			sfs.send(new ExtensionRequest("getDeity", extObj));
         }
		
	}
}
