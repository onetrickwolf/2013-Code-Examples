package
{
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// SmartFox Imports
	// SWC in relative SFS directory "../../SFS/SFS2X_API_AS3.swc"
	// Must unzip and rezip SWC for compatibility in FlashDevelop
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	import com.smartfoxserver.v2.SmartFox
	import com.smartfoxserver.v2.core.SFSEvent
	import com.smartfoxserver.v2.entities.*
	import com.smartfoxserver.v2.entities.data.*
	import com.smartfoxserver.v2.requests.*
	
	import flash.display.*
	import flash.events.*
	import flash.system.Security
	
	public class main extends Sprite
	{
		
		public static var sfs:SmartFox
		
		//private var buddy_system:BuddySystem;
		
		public function main()
		{
			
			//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			// SmartFox
			//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			sfs = new SmartFox()
			sfs.debug = true
			
			sfs.addEventListener(SFSEvent.CONNECTION, onConnection)
			sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost)
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoadSuccess)
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailure)
			sfs.addEventListener(SFSEvent.LOGIN, onLogin);
			sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
			
			connect();
			
			trace("SmartFox API: " + sfs.version)
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// SmartFox
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function connect()
		{
			sfs.loadConfig()
		}
		
		private function onConnection(evt:SFSEvent):void
		{
			if (evt.params.success)
			{
				trace("Connection Success!")
				sfs.send(new LoginRequest("Brent")); // Temp: Logs in as me as demo
			}
			else
			{
				trace("Connection Failure: " + evt.params.errorMessage)
			}
		}
		
		private function onConnectionLost(evt:SFSEvent):void
		{
			trace("Connection was lost. Reason: " + evt.params.reason)
		}
		
		private function onConfigLoadSuccess(evt:SFSEvent):void
		{
			trace("Config load success!")
			trace("Server settings: " + sfs.config.host + ":" + sfs.config.port)
		}
		
		private function onConfigLoadFailure(evt:SFSEvent):void
		{
			trace("Config load failure!!!")
		}
		
		public function onLogin(evt:SFSEvent):void
		{
			trace("Login success: " + evt.params.user.name);
			var buddy_system = new BuddySystem();
			buddy_system.x = 0;
			buddy_system.y = 0;
			this.addChild(buddy_system);
			this.setChildIndex(buddy_system, 3);
		}
		
		public function onLoginError(evt:SFSEvent):void
		{
			trace("Login failed: " + evt.params.errorMessage);
		}
	}

}