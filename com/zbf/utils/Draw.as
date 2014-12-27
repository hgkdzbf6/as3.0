package script.com.zbf.utils{
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.GraphicsGradientFill;
	import flash.display.IGraphicsData;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import script.com.zbf.engine.CrystalEngine;
	
	public class Draw {
		public static const TEXT_MARGIN_X:int = 20;
		public static const TEXT_MARGIN_Y:int = 10;
		
		public static const FORMAT_1:TextFormat = new TextFormat("微软雅黑", 18, 0x000000, true, null, null, "", "", "center");
		public static const FORMAT_2:TextFormat = new TextFormat("微软雅黑", 12, 0x417CBE,true);
		public static const FORMAT_3:TextFormat = new TextFormat("微软雅黑", 24, 0x4B75B4, true, false, false, "", "", "center");
		public static const FORMAT_4:TextFormat = new TextFormat("微软雅黑", 18, 0x4B75B4,true);
		public static const FORMAT_5:TextFormat = new TextFormat("微软雅黑", 33, 0x3337CC,true);
		public static const GRADIENT_0:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.LINEAR, [0x8B8B8B, 0xD2D2D2, 0xA8A8A8], [1, 1, 1], [0, 138, 255]);
		public static const GRADIENT_1:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.LINEAR, [0x36E0BA, 0xEDFFA6, 0x6BAFE7], [1, 1, 1], [0, 138, 255]);
		public static const GRADIENT_2:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.LINEAR, [0x3060F3, 0x23fff3, 0x7090f9], [1, 1, 1], [0, 127, 255]);
		public static const LIGHT_GRADIENT_1:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.RADIAL, [0xFFFFFF, 0xDE0000], [1, 1], [0, 40]);
		public static const LIGHT_GRADIENT_2:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.RADIAL, [0xFFFFFF,0xB524AA ], [1, 1], [0, 40]);
		public static const LIGHT_GRADIENT_3:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.RADIAL, [0xFFFFFF,0x3C59FF ], [1, 1], [0, 40]);
		public static const LIGHT_GRADIENT_4:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.RADIAL, [0xFFFFFF,0x529812 ], [1, 1], [0, 40]);
		public static const LIGHT_GRADIENT_5:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.RADIAL, [0xFFFFFF,0xBC6D03 ], [1, 1], [0, 40]);
		public static const LIGHT_GRADIENT_0:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.RADIAL, [0xFFFFFF,0x000000 ], [1, 1], [0, 40]);
		public static const LIGHT_GRADIENT_6:GraphicsGradientFill = new GraphicsGradientFill(
			GradientType.RADIAL, [0x8D88F7,0x000000 ], [1, 1], [0, 40]);
		public function Draw() {
			
		}
		public static function redrawCrystals(available:int,unavailable:int):Sprite {
			var sprite:Sprite = new Sprite();
			for (var i = 0; i < available; i++) {
				sprite.addChild(drawLight(new Point(i*16,  0), 8, Draw.LIGHT_GRADIENT_6));
			}
			for (; i < available+unavailable; i++) {
				sprite.addChild(drawLight(new Point(i*16,  0), 8, Draw.LIGHT_GRADIENT_0));
			}
			var rect:Shape = Draw.drawRect(0, 0, sprite.x, sprite.y,0xffffff);
			sprite.addChild(rect);
			return sprite;
		}
		public static function drawLight(point:Point,r:int,source:GraphicsGradientFill):Shape {
			var shape:Shape = new Shape();		
			//shape.graphics.lineStyle(1);
			shape.graphics.clear();
			var filters:Vector.< IGraphicsData> = new Vector.<IGraphicsData>(1, true);
			filters[0] = source;
			shape.graphics.drawGraphicsData(filters);
			shape.graphics.drawCircle(0, 0, r);
			shape.x = point.x;
			shape.y = point.y;
			shape.graphics.endFill();
			return shape;
		}
		public static function drawEllipse(px:int,py:int,w:int,h:int,color:uint):Shape {
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1);
			shape.graphics.beginFill(color,1);
			shape.graphics.drawEllipse(0, 0, w, h);
			shape.x = px;
			shape.y = py;
			shape.graphics.endFill();
			return shape;
		}
		public static function addFilter(target:Sprite,index:int=0) {
			var filters:Array = new  Array();
			switch(index) {
				case 0:
					var filter1:GlowFilter = new GlowFilter();
					filters.push(filter1);
					target.filters = [filter1];
					break;		
				case 1:
					var filter2:GlowFilter = new GlowFilter(0x0000FF);
					filters.push(filter2);
					target.filters = [filter2];
					break;
			}
		}
		
		public static function drawLabel(px:int, py:int, string:String,format:TextFormat=null):TextField
		{
			var label:TextField = new TextField();
			label.text = string;
			label.selectable = false;
			label.border = true;
			label.width = label.textWidth + 20+label.length*3;
			label.height = label.textHeight + 13;
			label.borderColor = 0x009090;
			label.setTextFormat(format);
			label.x = px - label.length * (Number(format.size)-4) / 2;
			label.y = py -  (format.size+10) / 2;
			return label;
		}
		public static function removeAllFilters(target:Sprite) {
			target.filters = [];
		}
		public static function drawLabelByPoint(point:Point ,string:String,format:TextFormat=null):TextField
		{
			return drawLabel(point.x, point.y, string, format);
		}
		public static function drawRectRoundCmd(source:BitmapData,px:int,py:int,w:int,h:int,str:String="",color:uint=0,format:TextFormat=null) {
			var cmd:Sprite = new Sprite();
			var cmdBack:Shape = new Shape();
			cmdBack.graphics.beginBitmapFill(source);
			cmdBack.graphics.drawRect(0, 0, w, h);
			cmdBack.graphics.endFill();
			cmdBack.x = px;
			cmdBack.y = py;
			cmd.addChild(cmdBack);
			if (!str == "") {
				var label:TextField = new TextField();
				label.text = str;
				label.height = h;
				label.width = w;
				label.x = px + 5;
				label.y = py + 45;
				label.mouseEnabled = false;
				label.setTextFormat(format);
				cmd.addChild(label);
			}
			cmd.buttonMode = true;
			cmd.useHandCursor = true;
			cmd.mouseChildren = false;
			return cmd;
		}
		public static function drawRect(px:int,py:int,w:int,h:int,color:uint,alpha:Number=0):Shape {
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1);
			shape.graphics.beginFill(color,alpha);
			shape.graphics.drawRect(0, 0, w, h);
			shape.x = px;
			shape.y = py;
			shape.graphics.endFill();
			return shape;
		}
		public static function drawCardBack(type:int,size:int,px:int,py:int):Shape {
			return drawBackgroundRect(type , px, py, size, size * Math.SQRT2);
		}		
		public static function drawMinionBack(type:int,size:int,px:int,py:int):Shape {
			return drawBackgroundEllipse(type , px, py, size, size * Math.SQRT2);
		}
		public static function drawConsoleBackground(w:int=500,h:int=300):Sprite {
			var sprite:Sprite = new Sprite();
			sprite.addChild(Draw.drawRect(0, 0, w, h, 0xf3a6b3, 0.5));
			
			return sprite;
		}
		public static function drawBackgroundEllipse(type:int,px:int,py:int,w:int,h:int):Shape {
			var shape:Shape = new Shape();
			var myMatrix:Matrix = new Matrix();
			var myMatrix2:Matrix = new Matrix();
			//myMatrix.createGradientBox(600, 600, 0, 0, -300);
			//myMatrix2.createGradientBox(400, 400, 0, 0, -200);
			shape.graphics.lineStyle(1);
			if (type == 0)
			{
				shape.graphics.beginGradientFill(GradientType.RADIAL, 
					[0x14BE1D, 0xFFFFFF], 
					[.9, .9], [0, 255],
					myMatrix,
					SpreadMethod.REFLECT,
					InterpolationMethod.RGB, 0);
			}else if (type == 1) {
				shape.graphics.beginGradientFill(GradientType.RADIAL, 
					[0xFFFFFF, 0x2DADD2], 
					[.9, .9], [0, 255],
					myMatrix2,
					SpreadMethod.REFLECT,
					InterpolationMethod.RGB, 0);
			}
			shape.graphics.drawEllipse(-w/2, -h/2, w, h);
			shape.graphics.endFill();
			shape.x = px+w/2;
			shape.y = py+w/2;
			return shape;
		}
		public static function drawBackgroundRect(type:int,px:int,py:int,w:int,h:int):Shape {
			var shape:Shape = new Shape();
			var myMatrix:Matrix = new Matrix();
			var myMatrix2:Matrix = new Matrix();
			//myMatrix.createGradientBox(600, 600, 0, 0, -300);
			//myMatrix2.createGradientBox(400, 400, 0, 0, -200);
			shape.graphics.lineStyle(1);
			if (type == 0)
			{
				shape.graphics.beginGradientFill(GradientType.RADIAL, 
					[0xFFFFFF, 0xB0ECC2], 
					[.9, .9], [0, 255],
					null,
					SpreadMethod.REFLECT,
					InterpolationMethod.RGB, 0);
			}else if (type == 1) {
				shape.graphics.beginGradientFill(GradientType.RADIAL, 
					[0xFFFFFF, 0xB6E0EB], 
					[.9, .9], [0, 255],
					null,
					SpreadMethod.REFLECT,
					InterpolationMethod.RGB, 0);
			}
			shape.graphics.drawRect(-w/2, -h/2, w, h);
			shape.graphics.endFill();		
			shape.x = px+w/2;
			shape.y = py+h/2;
			return shape;
		}
		public static function drawTextField(px:int, py:int,format:TextFormat=null,isMultiline:Boolean=false):TextField
		{
			var text:TextField = new TextField();
			text.setTextFormat(format);
			text.x = px;
			text.y = py;
			text.height = 20;
			text.type = TextFieldType.INPUT;
			text.border = true;
			text.borderColor = 0xF10309;
			text.selectable = true;
			text.multiline = isMultiline;
			text.textColor = 0x408080;
			return text;
		}
		public static function drawCmd(str:String,format:TextFormat,source:GraphicsGradientFill,px:int,py:int,w:int,h:int):Sprite {
			var sprite:Sprite = new Sprite();
			var label:TextField = drawLabel(0, 0, str, format);
			var filters:Vector.< IGraphicsData> = new Vector.<IGraphicsData>(1, true);
			filters[0] = source;
			sprite.graphics.drawGraphicsData(filters);
			sprite.graphics.drawRect(-w/2, -h/2, w, h);
			sprite.graphics.endFill();
			sprite.x = px + w / 2;
			sprite.y = py + h / 2;
			sprite.addChild(label);
			return sprite;
		}
		public static function drawCharacter(str:String):Sprite {
			var sprite:Sprite = new Sprite();
			sprite.addChild(drawEllipse(0, 0, 100, 100, 0x72DB24));
			sprite.addChild(drawEllipse(20, 28, 14, 14, 0xFFFFFF));
			sprite.addChild(drawEllipse(64, 28, 14, 14, 0xFFFFFF));
			return sprite;
		}
	}
	
}
