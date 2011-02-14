package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class Heart extends Entity
	{
		// embed the asset
		[Embed(source="assets/heart.png")] static private const HEART_PNG:Class;
		
		// maximum supported display is 10 hearts
		static private const MAX_HEARTS_DISPLAYED:int = 11;
		
		// number of pixels between each heart
		static private const HEART_GAP:int = 8;
		
		// the heart bitmap width plus the gap of pixels is the spacing
		static private var heartSpacing:int;
		
		// will hold the embedded heart bitmap
		static private var heartBmp:BitmapData;
		
		// will hold a tiled bar of the hearts bitmap
		static private var templateBmp:BitmapData;
		
		// clipping rectangle for the display
		private var myClip:Rectangle;
		
		// the display image
		private var myImage:Image;
		
		// the number of hearts to display
		private var myCount:Number;
		
		// returns the number of hearts
		public function get Count():Number { return myCount; }
		
		// updates the number of hearts
		public function set Count(value:Number):void
		{
			// prevent count from being negative
			if (value < 0) { value = 0; }
			
			// keep count within limits
			if (value >= MAX_HEARTS_DISPLAYED) { value = MAX_HEARTS_DISPLAYED -1; }
			
			myCount = value;
			
			UpdateHeartsDisplay();
		}
		
		// initializes the display
		public function Heart(xPos:Number, yPos:Number, count:Number = 10) 
		{
			// the first time the class is instantiated, the display is created
			if (heartBmp == null)
			{
				CreateHeartsDisplay();	
			}
			
			// position the display
			super(xPos, yPos);
			
			// prevent count from being negative
			if (count < 0) { count = 0; }
			
			// keep count within limits
			if (count >= MAX_HEARTS_DISPLAYED) { count = MAX_HEARTS_DISPLAYED -1; }
			
			// finally set the count var
			myCount = count;
			
			// create the clipping rectangle
			myClip = new Rectangle(0, 0, heartSpacing * myCount, templateBmp.height);
			
			// create the image 
			myImage = new Image(templateBmp, myClip);
			graphic = myImage;
		}
		
		// creates the display
		private function CreateHeartsDisplay():void 
		{
			heartBmp = FP.getBitmap(HEART_PNG);
			
			// spacing of hearts
			heartSpacing = (heartBmp.width + HEART_GAP);
			
			// create a template of the heart image tiled
			templateBmp = new BitmapData(MAX_HEARTS_DISPLAYED * heartSpacing, heartBmp.height, true, 0x00000000);
			
			// tile the heart bitmap across our template
			var pos:Point = new Point;
			for (var i:int = 0; i < MAX_HEARTS_DISPLAYED; i++)
			{
				pos.x = heartSpacing * i;
				templateBmp.copyPixels(heartBmp, heartBmp.rect, pos);
			}
		}
		
		private function UpdateHeartsDisplay():void
		{
			// update the clipping rectangle for the display image
			
			myClip.right = heartSpacing * myCount;
			myImage.clear();
			myImage.updateBuffer();
			
			// update the Entity graphic
			graphic = myImage;
		}
	}
}