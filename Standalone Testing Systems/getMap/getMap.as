package 
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.*;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.requests.*;
	import com.smartfoxserver.v2.logging.*;
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	public class getMap extends Sprite
	{
		private var sfs:SmartFox;
		private var autoJoin:Boolean = false;
		public function getMap()
		{
			sfs = new SmartFox();
			sfs.debug = true;
			sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
			sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoadSuccess);
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailure);
			sfs.addEventListener(SFSEvent.LOGIN, onLogin);
			sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
			sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);

			bt_connect.addEventListener(MouseEvent.CLICK, onBtConnectClick);
			dTrace("SmartFox API: "+ sfs.version);
			dTrace("Click CONNECT to start...");
		}

		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Button Handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function onBtConnectClick(evt:Event):void
		{
			sfs.loadConfig();
		}


		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Event Handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

		private function onConnection(evt:SFSEvent):void
		{
			ta_debug.text = "";
			if (evt.params.success)
			{
				dTrace("Connection Success!");
				sfs.send(new LoginRequest());
			}
			else
			{
				dTrace("Connection Failure: " + evt.params.errorMessage);
			}
		}

		private function onConnectionLost(evt:SFSEvent):void
		{
			dTrace("Connection was lost. Reason: " + evt.params.reason);
		}

		private function onLogin(evt:SFSEvent):void
		{
			dTrace("Logged in as: " + evt.params.user.name);
			
			var params:ISFSObject = new SFSObject();
         	params.putInt("mapID", 1);
			
			sfs.send(new ExtensionRequest("getMap", params));
		}

		private function onLoginError(evt:SFSEvent):void
		{
			dTrace("Login Failure: " + evt.params.errorMessage);
		}


		private function onConfigLoadSuccess(evt:SFSEvent):void
		{
			dTrace("Config load success!");
		}

		private function onConfigLoadFailure(evt:SFSEvent):void
		{
			dTrace("Config load failure!!!");
		}

		private function onExtensionResponse(evt:SFSEvent):void
		{
			var params:ISFSObject = evt.params.params as ISFSObject;
			var mapArray:ISFSArray = params.getSFSArray("maps");
			var dump:String = "MAP LIST RECEIVED:\n\n";
			for (var i:int = 0; i < mapArray.size(); i++)
			{
				var item:ISFSObject = mapArray.getSFSObject(i);
				dump +=  "    > " + item.getUtfString("NAME") + "\r    > " + item.getUtfString("MAP_DATA") + "\r    > " + item.getUtfString("STATUS") + "\n";
			}
			
			var parsedArray:ISFSArray = params.getSFSArray("parsedArray");
			for (i = 0; i < parsedArray.size(); i++)
			{
				item = parsedArray.getSFSObject(i);
				dump +=  i+"   > " 
				+ item.getInt("xCord") + "\r    > " 
				+ item.getInt("yCord") + "\r    > " 
				+ item.getUtfString("hexLabel") + "\r    > "  
				+ item.getUtfString("landmass") + "\r    > "  
				+ item.getUtfString("props") + "\n";
			}

			var parsedMap:Array = params.getUtfStringArray("parsedMap");
			for (i = 0; i < parsedMap.length; i++)
			{
				dump +=  "\r    >> " + parsedMap[i];
			}

			dTrace(dump);
			dTrace("Total records: " + (parsedArray.size()));
		}

		private function dTrace(msg:String):void
		{
			ta_debug.text +=  "--> " + msg + "\n";
		}

	}
}