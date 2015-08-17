package
{
	
	import com.smartfoxserver.v2.core.SFSBuddyEvent;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.buddylist.BuddyMessageRequest;
	import flash.display.Sprite;
	import com.smartfoxserver.v2.entities.Buddy;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	
	public class ChatWindow extends Sprite
	{
		
		public var buddy:Buddy
		
		public function ChatWindow(buddy:Buddy)
		{
			this.buddy = buddy;
			chat_name.text = buddy.name;
			chat_body.htmlText = "";
			if (buddy.isOnline)
			{
				status.gotoAndStop("green");
			}
			else
			{
				status.gotoAndStop("gray");
				chat_body.htmlText += "Buddy offline";
				chat_input.selectable = false;
				chat_input.type = TextFieldType.DYNAMIC;
			}
			chat_input.text = "";
			cWScrollBG.visible = false;
			bt_cWScroll.visible = false;
			
			chat_input.addEventListener(KeyboardEvent.KEY_DOWN, enterHandler, false, 0, true);
			
			bt_close.addEventListener(MouseEvent.CLICK, buttonHandler, false, 0, true);
			
			main.sfs.addEventListener(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE, onBuddyStateUpdate, false, 0, true);
			main.sfs.addEventListener(SFSBuddyEvent.BUDDY_MESSAGE, onBuddyMessage, false, 0, true);
		}
		
		private function buttonHandler(e:MouseEvent):void
		{
			BuddySystem.buddyList.visible = true;
			parent.removeChild(this);
		}
		
		private function onBuddyStateUpdate(e:Event):void
		{
			if (buddy.isOnline)
			{
				status.gotoAndStop("green");
				chat_input.selectable = true;
				chat_input.type = TextFieldType.INPUT;
			}
			else
			{
				status.gotoAndStop("gray");
				chat_input.selectable = false;
				chat_input.type = TextFieldType.DYNAMIC;
			}
		}
		
		private function enterHandler(event:KeyboardEvent)
		{
			if (event.charCode == 13)
			{
				sendMessageToBuddy(chat_input.text);
			}
		}
		
		private function sendMessageToBuddy(message:String):void
		{
			var params:ISFSObject = new SFSObject();
			params.putUtfString("recipient", buddy.name);
			
			main.sfs.send(new BuddyMessageRequest(message, buddy, params));
			chat_input.text = "";
		}
		
		private function onBuddyMessage(evt:SFSBuddyEvent):void
		{
			var isItMe:Boolean = evt.params.isItMe;
			var sender:Buddy = evt.params.buddy;
			var message:String = evt.params.message;
			
			if (isItMe)
			{
				var buddyName:String = (evt.params.data as ISFSObject).getUtfString("recipient");
				chat_body.htmlText += "<b>" + (isItMe ? "You" : sender.name) + ":</b> " + message
				chat_body.scrollV = chat_body.maxScrollV;
			}		
			else if (sender.name == buddy.name)
			{
				chat_body.htmlText += "<b>" + (isItMe ? "You" : sender.name) + ":</b> " + message
				chat_body.scrollV = chat_body.maxScrollV;
			}
		
		}
	}

}
