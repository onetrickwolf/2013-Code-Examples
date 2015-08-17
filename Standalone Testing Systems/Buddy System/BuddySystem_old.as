package  {
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSBuddyEvent;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.Buddy;
	import com.smartfoxserver.v2.entities.SFSBuddy;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.variables.BuddyVariable;
	import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
	import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
	import com.smartfoxserver.v2.requests.buddylist.AddBuddyRequest;
	import com.smartfoxserver.v2.requests.buddylist.BlockBuddyRequest;
	import com.smartfoxserver.v2.requests.buddylist.BuddyMessageRequest;
	import com.smartfoxserver.v2.requests.buddylist.GoOnlineRequest;
	import com.smartfoxserver.v2.requests.buddylist.InitBuddyListRequest;
	import com.smartfoxserver.v2.requests.buddylist.RemoveBuddyRequest;
	import com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest;
	import com.smartfoxserver.v2.util.ClientDisconnectionReason;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flashx.textLayout.elements.ListItemElement;
	
	import flash.text.*;
	
	public class BuddySystem extends MovieClip {
		
		var yOffset:Number;
		var topLimit:Number;
		var scrollbarRange:Number;
		var bottomLimit:Number;
	
		var scrollPercent:Number = 0;
		
		var contentRange:Number;
		var sfs:SmartFox;
		
		var buddies:Array;
		
		var window:MovieClip;
		var scrollbar:MovieClip;
		var track:MovieClip;
		var status:MovieClip;
		var container:MovieClip;
		
		var selected_buddy:Buddy;
		
		public function BuddySystem() {
			window = BuddyList.window;
			scrollbar = BuddyList.scrollbar;
			track = BuddyList.track;
			status = BuddyList.status;
			container = BuddyList.container;
			
			ChatWindow.visible = false;
			
			buddies = new Array();
			
			sfs = main.sfs;
			sfs.addEventListener(SFSBuddyEvent.BUDDY_LIST_INIT, onBuddyListInit);
			sfs.addEventListener(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE, onBuddyListUpdate);
			sfs.addEventListener(SFSBuddyEvent.BUDDY_MESSAGE, onBuddyMessage);
			sfs.send(new InitBuddyListRequest());

			scrollbar.buttonMode = true;
			scrollbar.addEventListener(MouseEvent.MOUSE_DOWN, scrollbar_onMouseDown);
			topLimit = track.y;
			scrollbarRange = track.height - scrollbar.height;
			bottomLimit = track.y + scrollbarRange;

		    contentRange = container.height - window.height;
			container.mask = window;
			container.x = window.x;
			container.y = window.y;
			status.gotoAndStop("green");
			
			sideMenu.visible = false;
			
			sideMenu.sideMenuText.addEventListener(TextEvent.LINK, linkHandler);
			
			ChatWindow.chatInput.addEventListener(KeyboardEvent.KEY_DOWN,enterHandler);

		}
		function scrollbar_onMouseDown(event:MouseEvent):void {
			yOffset = mouseY - scrollbar.y;
			root.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
			root.stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
		}
	
		function stage_onMouseMove(event:MouseEvent):void {
			scrollbar.y = mouseY - yOffset;

			if(scrollbar.y < topLimit) {
				scrollbar.y = topLimit;
			}
			if(scrollbar.y > bottomLimit) {
				scrollbar.y = bottomLimit;
			}
			scrollPercent = (scrollbar.y - track.y) / scrollbarRange;
			container.y = window.y - (scrollPercent * contentRange);
			event.updateAfterEvent();
		}
		
		function stage_onMouseUp(event:MouseEvent):void {
			root.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
			root.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
		}
		
		private function onBuddyListInit(evt:SFSBuddyEvent):void
		{
			trace(sfs.buddyManager.buddyList);
			// Populate list of buddies
			onBuddyListUpdate(evt);
			
			// Set current user details as buddy
			/*
			// Nick
			ti_nick.text = sfs.buddyManager.myNickName;
			
			// States
			var states:Array = sfs.buddyManager.buddyStates;
			dd_states.dataProvider = states;
			var state:String = (sfs.buddyManager.myState != null ? sfs.buddyManager.myState : "");
			if (states.indexOf(state) > -1)
				dd_states.selectedIndex = states.indexOf(state);
			else
				dd_states.selectedIndex = 0;
			
			// Online
			cb_online.selected = sfs.buddyManager.myOnlineState;
				
			// Buddy variables
			var age:BuddyVariable = sfs.buddyManager.getMyVariable(BUDDYVAR_AGE);
			ns_age.value = ((age != null && !age.isNull()) ? age.getIntValue() : 30);
			
			var mood:BuddyVariable = sfs.buddyManager.getMyVariable(BUDDYVAR_MOOD);
			ti_mood.text = ((mood != null && !mood.isNull()) ? mood.getStringValue() : "");
			
			isBuddyListInited = true;*/
		}
		
		private function onBuddyListUpdate(evt:SFSBuddyEvent):void
		{
			var counter:Number = 0;
			var onlineCounter = 0;
			for(var i = 0; i < buddies.length; i++){
				buddies[i].removeEventListener(MouseEvent.CLICK, buddyClickHandler);
				container.removeChild(buddies[i]);
			}
			buddies = new Array();
			for each (var buddy:Buddy in sfs.buddyManager.buddyList)
			{
				
				// Refresh the buddy chat tab (if open) so that it matches the buddy state
				var item:ListItem = new ListItem();
				item.buddy_name.text = buddy.name;
				if(buddy.isOnline){
					item.status.gotoAndStop("green");
					onlineCounter++;
				} else {
					item.status.gotoAndStop("gray");
				}
				item.gotoAndStop("idle");
				item.y = (40 * counter);
				item.buttonMode = true;
				item.mouseChildren = false;
				item.buddy = buddy;
				item.addEventListener(MouseEvent.CLICK, buddyClickHandler);
				container.addChild(item);
				buddies.push(item);
				counter++;
				/*if (tab != null)
				{
					tab.buddy = buddy;
					tab.refresh();
					
					// If a buddy was blocked, close its tab
					if (buddy.isBlocked)
						stn_chats.removeChild(tab);
				}*/
			}
			
			//ls_buddies.dataProvider = buddies;
			contentRange = container.height - window.height;
			FriendNumDisplay.numFriendsOnline.text = onlineCounter;
		}

		function buddyClickHandler(event:MouseEvent):void {
			selected_buddy = event.target.buddy;
			
			var HTMLText:String = "<a href='event:chatLink'>Chat</a>\n"+
									"<a href='event:inviteLink'>Invite</a>\n";

			var CSS:StyleSheet = new StyleSheet();
			CSS.setStyle("a:link", {color:'#67594f',textDecoration:'underline'});
			CSS.setStyle("a:hover", {color:'#e15e00',textDecoration:'underline'});
			sideMenu.sideMenuText.styleSheet = CSS;
			sideMenu.sideMenuText.htmlText = HTMLText;
			
			sideMenu.visible = true;
		}
		
		function linkHandler(linkEvent:TextEvent):void {
			switch (linkEvent.text) {
				case "chatLink":
					trace("chat");
					ChatWindow.visible = true;
					BuddyList.visible = false;
					ChatWindow.chatInput.text = "";
					ChatWindow.chatBody.text = "";
					break;
				case "inviteLink":
					trace("invite");
					break;
				default:
					trace("default");
			}
		}
		
		function enterHandler(event:KeyboardEvent){
		   if(event.charCode == 13){
			   sendMessageToBuddy(ChatWindow.chatInput.text, selected_buddy);
		   }
		}
		
		public function sendMessageToBuddy(message:String, buddy:Buddy):void
		{
			var params:ISFSObject = new SFSObject();
			params.putUtfString("recipient", buddy.name);
			
			sfs.send(new BuddyMessageRequest(message, buddy, params));
			ChatWindow.chatInput.text = "";
		}
		private function onBuddyMessage(evt:SFSBuddyEvent):void
		{
			var isItMe:Boolean = evt.params.isItMe;
			var sender:Buddy = evt.params.buddy;
			var message:String = evt.params.message;
			
			var buddy:Buddy;
			
			if (isItMe)
			{
				var buddyName:String = (evt.params.data as ISFSObject).getUtfString("recipient");
				buddy = sfs.buddyManager.getBuddyByName(buddyName);
			}
			else
				buddy = sender;
			
			if (buddy != null)
			{
				var old = ChatWindow.chatBody.htmlText;
				ChatWindow.chatBody.htmlText = "<b>" + (isItMe ? "You" : sender.name) + ":</b> " + message + "\n" + old;
			}
		}
		
	}
}
