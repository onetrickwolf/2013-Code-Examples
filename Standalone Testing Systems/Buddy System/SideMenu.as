package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SideMenu extends Sprite
	{
		public function SideMenu()
		{
			trace("SideMenu init");
			bt_invite.addEventListener(MouseEvent.CLICK, buttonHandler, false, 0, true);
			bt_message.addEventListener(MouseEvent.CLICK, buttonHandler, false, 0, true);
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Button handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function buttonHandler(e:MouseEvent):void
		{
			trace(e.target.name + " " + BuddyList(parent).bLSelectedBuddy.name) // bad practice...you should really pass the reference
			this.visible = false;
			
			switch (e.target)
			{
				case bt_invite: 
					break;
				
				case bt_message: 
					trace("bt_mesage");
					BuddyList(parent).visible = false;
					
					var chatWindow:ChatWindow = new ChatWindow(BuddyList(parent).bLSelectedBuddy);
					chatWindow.x = 490;
					chatWindow.y = 63;
					BuddySystem(parent.parent).addChild(chatWindow);
					break;
			}
		}
	}

}
