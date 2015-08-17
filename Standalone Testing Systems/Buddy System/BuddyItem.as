package
{
	
	import com.smartfoxserver.v2.entities.Buddy;
	import flash.display.Sprite;
	
	public class BuddyItem extends Sprite
	{
		
		public var buddy:Buddy
		
		public function BuddyItem(buddy:Buddy)
		{
			this.buddy = buddy;
			buddy_name.text = buddy.name;
			if (buddy.isOnline)
			{
				status.gotoAndStop("green");
			}
			else
			{
				status.gotoAndStop("gray");
			}
		}
	}

}
