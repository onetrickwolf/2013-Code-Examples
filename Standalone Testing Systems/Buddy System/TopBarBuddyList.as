package
{
	
	import com.smartfoxserver.v2.core.SFSBuddyEvent;
	import com.smartfoxserver.v2.entities.Buddy;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TopBarBuddyList extends Sprite
	{
		
		// This is just for demo purposes. The final version should use a real scrolling and item system.
		private var tempText:String = "";
		private var tempBuddy:Buddy;
		
		public function TopBarBuddyList()
		{
			
			item_one.addEventListener(MouseEvent.CLICK, buttonHandler, false, 0, true);
			item_one.buttonMode = true;
			item_one.mouseChildren = false;
			item_one.stop();
			item_one.buddy_name.text = "";
			//bt_changeStatus.status.stop();
			item_two.buttonMode = true;
			item_two.mouseChildren = false;
			item_two.stop();
			item_two.buddy_name.text = "N/A";
			
			main.sfs.addEventListener(SFSBuddyEvent.BUDDY_MESSAGE, onBuddyMessage, false, 0, true);
		
		}
		
		public function buttonHandler(e:MouseEvent):void
		{
			BuddySystem.buddyList.visible = false;
			
			var chatWindow:ChatWindow = new ChatWindow(tempBuddy);
			chatWindow.x = 490;
			chatWindow.y = 63;
			chatWindow.chat_body.htmlText = tempText;
			BuddySystem(parent).addChild(chatWindow);
		}
		
		private function onBuddyMessage(evt:SFSBuddyEvent):void
		{
			var isItMe:Boolean = evt.params.isItMe;
			var sender:Buddy = evt.params.buddy;
			var message:String = evt.params.message;
			
			if (!isItMe)
			{
				item_one.buddy_name.text = sender.name.slice(0, 5) + "...";
			}
			tempBuddy = sender;
			tempText += "<b>" + (isItMe ? "You" : sender.name) + ":</b> " + message + "\r";
		
		}
	}

}
