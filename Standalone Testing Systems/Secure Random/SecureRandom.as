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
	public class SecureRandom extends Sprite
	{
		private var sfs:SmartFox;
		private var autoJoin:Boolean = false;

		private var seed = 0;

		public function SecureRandom()
		{
			sfs = new SmartFox  ;
			sfs.debug = true;
			sfs.addEventListener(SFSEvent.CONNECTION,onConnection);
			sfs.addEventListener(SFSEvent.CONNECTION_LOST,onConnectionLost);
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,onConfigLoadSuccess);
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE,onConfigLoadFailure);
			sfs.addEventListener(SFSEvent.LOGIN,onLogin);
			sfs.addEventListener(SFSEvent.LOGIN_ERROR,onLoginError);
			sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE,onExtensionResponse);

			bt_connect.addEventListener(MouseEvent.CLICK,onBtConnectClick);
			dTrace("SmartFox API: " + sfs.version);
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
				sfs.send(new LoginRequest  );
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
			sfs.send(new ExtensionRequest("getRandom",new SFSObject  ));
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
			if (evt.params.cmd == "getRandom")
			{
				seed = params.getLong("seed");
				var exampleArray:ISFSArray = params.getSFSArray("example");

				var dump:String = "SEED RECEIVED (that's what she said):\n\n";
				dump +=  "SEED: " + seed + "\n\n";
				dump +=  "Server Calculations: \n";
				for (var i:int = 0; i < exampleArray.size(); i++)
				{
					var item:Number = exampleArray.getDouble(i);
					dump +=  "(" + item + ")";
				}

				dump +=  "\n\nClient Calculations: \n";

				for (i = 0; i < exampleArray.size(); i++)
				{
					dump +=  "(" + getRandom() + ")";
				}

				dTrace(dump);
			}
		}

		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Random Functions
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

		function getRandom():Number
		{
			seed = (seed * 9301 + 49297) % 233280;
			return seed / (233280.0);
		}

		function getNumInRange(bottom:Number,top:Number):Number {
			var dif:Number = top-bottom+1;
			var num:Number = getRandom();
			return bottom+(dif*num);
		}

		function getIntInRange(bottom:Number,top:Number):Number {
			var dif:Number = top-bottom+1;
			var num:Number = getRandom();
			return Math.floor( bottom+(dif*num) );
		}
	
	
		function getBoolean(Void):Boolean {
			return getRandom() < .5;
		}

		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Output Functions
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

		private function dTrace(msg:String):void
		{
			ta_debug.text +=  "--> " + msg + "\n";
		}

	}
}