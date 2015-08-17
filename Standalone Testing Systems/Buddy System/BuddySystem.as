package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BuddySystem extends Sprite
	{
		public static var buddyList:BuddyList;
		public static var topBarBuddyList:TopBarBuddyList;
		
		public function BuddySystem()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true); // useWeakReference = true for better garbage collecting
			bt_openList.addEventListener(MouseEvent.CLICK, buttonHandler, false, 0, true);
		}
		
		private function buttonHandler(e:MouseEvent):void
		{
			if (buddyList.visible)
			{
				buddyList.visible = false;
			}
			else
			{
				buddyList.visible = true;
			}
		}
		
		private function onAddedToStage(e:Event):void
		{
			buddyList = new BuddyList();
			buddyList.x = 490;
			buddyList.y = 63;
			buddyList.visible = false;
			addChild(buddyList);
			
			topBarBuddyList = new TopBarBuddyList();
			topBarBuddyList.x = 483;
			topBarBuddyList.y = 33;
			addChild(topBarBuddyList);
		}
		
	}
}