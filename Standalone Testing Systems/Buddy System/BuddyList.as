package
{
	import com.smartfoxserver.v2.core.SFSBuddyEvent;
	import com.smartfoxserver.v2.entities.Buddy;
	import com.smartfoxserver.v2.requests.buddylist.InitBuddyListRequest;
	import com.smartfoxserver.v2.SmartFox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class BuddyList extends Sprite
	{
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Objects
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private var sfs:SmartFox;
		private var buddies:Array = new Array();
		public var bLSelectedBuddy:Buddy;
		
		private var footerBounds:Rectangle; // Footer is used to resize the buddy list
		
		private var yOffset:Number; // Stops scrolls from jumping
		private var scrollPercent:Number = 0;
		
		private var bLSideMenu:SideMenu;

		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Initiators
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		public function BuddyList()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true); // useWeakReference = true for better garbage collecting
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
		}
		
		private function onAddedToStage(e:Event):void
		{
			// SFS
			sfs = main.sfs;
			sfs.addEventListener(SFSBuddyEvent.BUDDY_LIST_INIT, onBuddyListInit, false, 0, true);
			sfs.addEventListener(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE, onBuddyListUpdate, false, 0, true);
			
			sfs.send(new InitBuddyListRequest());
			
			// Header buttons
			bt_addFriend.addEventListener(MouseEvent.CLICK, buttonHandler, false, 0, true);
			
			bt_changeStatus.addEventListener(MouseEvent.CLICK, buttonHandler, false, 0, true);
			bt_changeStatus.buttonMode = true;
			bt_changeStatus.mouseChildren = false;
			bt_changeStatus.stop();
			bt_changeStatus.status.stop();
			
			// Footer
			footerBounds = new Rectangle(3, 119, 0, 300);
			
			bt_bLFooter.addEventListener(MouseEvent.MOUSE_DOWN, buttonHandler, false, 0, true);
			bt_bLFooter.buttonMode = true;
			bt_bLFooter.mouseChildren = false;
			
			// Scrollbar
			bt_bLScroll.addEventListener(MouseEvent.MOUSE_DOWN, buttonHandler, false, 0, true);
			bt_bLScroll.buttonMode = true;
			bt_bLScroll.mouseChildren = false;
			
			bLScrollBG.visible = false;
			bt_bLScroll.visible = false;
			
			// Container (the actual list)
			bLContainer.mask = bLMask;
			
			// Side Menu
			bLSideMenu = new SideMenu();
			bLSideMenu.visible = false;
			bLSideMenu.x -= bLSideMenu.width - 4;
			bLSideMenu.y = 37;
			bLSideMenu.bt_spectate.enabled = false;
			addChild(bLSideMenu);
			
			// Remove listner
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// SmartFox handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function onBuddyListInit(e:SFSBuddyEvent):void
		{
			trace(sfs.buddyManager.buddyList);
			onBuddyListUpdate(e);
		}
		
		private function onBuddyListUpdate(e:SFSBuddyEvent):void
		{
			var counter:Number = 0;
			var onlineCounter:Number = 0;
			
			// Clear list
			for (var i = 0; i < buddies.length; i++)
			{
				buddies[i].removeEventListener(MouseEvent.CLICK, buddyClickHandler);
				buddies[i].buddy = null;
				bLContainer.removeChild(buddies[i]);
				buddies[i] = null;
			}
			
			buddies = new Array();
			
			// Populate list
			for each (var buddy:Buddy in sfs.buddyManager.buddyList)
			{
				var item:BuddyItem = new BuddyItem(buddy);
				item.y = (41 * counter);
				item.buttonMode = true;
				item.mouseChildren = false;
				item.addEventListener(MouseEvent.CLICK, buddyClickHandler);
				bLContainer.addChild(item);
				buddies.push(item);
				counter++;
				if(buddy.isOnline){ onlineCounter++ }
			}
			
			adjustScroll();
			BuddySystem(parent).buddy_num.text = String(onlineCounter);
		}
		
		private function buddyClickHandler(e:MouseEvent):void
		{
			bLSideMenu.visible = true;
			bLSelectedBuddy = e.target.buddy;
			trace(bLSelectedBuddy.name);
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Button handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function buttonHandler(e:MouseEvent):void
		{
			trace(e.target.name)
			switch (e.target)
			{
				case bt_addFriend: 
					break;
				
				case bt_changeStatus: 
					break;
				
				case bt_bLFooter: 
					yOffset = mouseY - bt_bLFooter.y;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove, false, 0, true);
					stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp, false, 0, true);
					break;
				
				case bt_bLScroll: 
					yOffset = mouseY - bt_bLScroll.y;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMoveScroll, false, 0, true);
					stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUpScroll, false, 0, true);
					break;
			}
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Scroll handling
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function stage_onMouseMoveScroll(e:MouseEvent):void
		{
			bt_bLScroll.y = mouseY - yOffset;
			
			if (bt_bLScroll.y < 38)
			{
				bt_bLScroll.y = 38;
			}
			if (bt_bLScroll.y > 7 + bLScrollBG.height)
			{
				bt_bLScroll.y = 7 + bLScrollBG.height;
			}
			
			scrollPercent = (bt_bLScroll.y - bLScrollBG.y) / (bLScrollBG.height - bt_bLScroll.height);
			bLContainer.y = Math.ceil(bLMask.y - (scrollPercent * (bLContainer.height - bLMask.height)));
			
			e.updateAfterEvent();
		}
		
		private function stage_onMouseUpScroll(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMoveScroll);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUpScroll);
		}
		
		private function adjustScroll()
		{
			// Show/hide scrollbar
			if (bLContainer.height < bLMask.height + 3)
			{
				bLScrollBG.visible = false;
				bt_bLScroll.visible = false;
			}
			else
			{
				// Show more of the container as the footer expands
				scrollPercent = (bt_bLScroll.y - bLScrollBG.y) / (bLScrollBG.height - bt_bLScroll.height);
				bLContainer.y = Math.ceil(bLMask.y - (scrollPercent * (bLContainer.height - bLMask.height)));
				
				bLScrollBG.visible = true;
				bt_bLScroll.visible = true;
			}
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Footer resize handling
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function stage_onMouseMove(e:MouseEvent):void
		{
			bt_bLFooter.y = mouseY - yOffset;
			
			if (bt_bLFooter.y < footerBounds.y)
			{
				bt_bLFooter.y = footerBounds.y;
			}
			if (bt_bLFooter.y > footerBounds.y + footerBounds.height)
			{
				bt_bLFooter.y = footerBounds.y + footerBounds.height;
			}
			
			bLBG.height = bt_bLFooter.y - 38;
			bLMask.height = bt_bLFooter.y - 38;
			
			// Bring scroll button up when footer is resized
			
			bLScrollBG.height = Math.ceil(bt_bLFooter.y - 37);
			
			if (bt_bLScroll.y > 7 + bLScrollBG.height)
			{
				bt_bLScroll.y = 7 + bLScrollBG.height;
			}
			
			adjustScroll();
			
			e.updateAfterEvent();
		}
		
		private function stage_onMouseUp(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Destructors
		// Automatically cleans up memory if removed from stage
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function onRemovedFromStage(e:Event):void
		{
			// Remove SFS objects and listeners
			sfs = null;
			
			sfs.removeEventListener(SFSBuddyEvent.BUDDY_LIST_INIT, onBuddyListInit);
			sfs.removeEventListener(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE, onBuddyListUpdate);
			
			// Remove header button listners
			bt_addFriend.removeEventListener(MouseEvent.CLICK, buttonHandler);
			
			bt_changeStatus.removeEventListener(MouseEvent.CLICK, buttonHandler);
			
			// Remove footer objects and listeners
			footerBounds = null;
			
			bt_bLFooter.removeEventListener(MouseEvent.MOUSE_DOWN, buttonHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
			
			// Scrollbar
			bt_bLScroll.removeEventListener(MouseEvent.MOUSE_DOWN, buttonHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMoveScroll);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUpScroll);
			
			// Side Menu
			removeChild(bLSideMenu);
			bLSideMenu = null;
			
			bLSelectedBuddy = null;
			
			// Remove listner
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
	
	}

}
