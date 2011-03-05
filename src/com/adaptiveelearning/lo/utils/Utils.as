package com.adaptiveelearning.lo.utils {

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;
	
	public class Utils {
		
		public static function getClassName(obj:*):String {
			var fullName:String = flash.utils.getQualifiedClassName(obj);
			var startIndex:int = fullName.indexOf("::");
			if (startIndex == -1) startIndex = -2;
			return (fullName.substr(startIndex+2,fullName.length-1));
		}
		
				
		
		public static function arrayHasIndex(array:Object,index:Number):Boolean{
			if (array == null || isNaN(index) || index <0 || index > (array.length-1) || Math.round(index) != index ){
				return false;
			}
			try {
				var o:* = array[index];
				return true;
			} catch (error:Error) {
				
			}
			return false;
		}
		
		
		
		public static function isVisible(c : DisplayObject) : Boolean {
		    if (c == null) return false;
		    if (c is Stage) return c.visible;
		    return c.visible && isVisible(c.parent);
		}
		
		
		public static function randomSelectFromArray(arr:Array,n:Number):Array {
			if (n> arr.length) {
				return null;
			}
			
			var options:Array = new Array();
			for(var key:* in arr) {
				options.push(arr[key]);
			}
	
			var rArray:Array = new Array();
			for (var i:int=0;i<n;i++) {
				var index:Number = Math.floor(Math.random()*options.length); 
				var pick:* = options[index];
				options.splice(index,1);
				rArray.push(pick);
			}
			return rArray;
		}
		
		
		public static function localToLocal(containerFrom:DisplayObject, containerTo:DisplayObject, origin:Point=null):Point {
            var point:Point = origin ? origin : new Point();
            point = containerFrom.localToGlobal(point);
            point = containerTo.globalToLocal(point);
            return point;
        }
		
	
		public static function convertStringToType(type:String,valueStr:String):* {
			var value:* = valueStr;
			if (type == null) { return 
				valueStr;
			} 
			
			if (valueStr == null) {
				return null;
			}
			if (type.toLowerCase() == "array") { // meaning arrays should look like  "a,b,c"    
				return  valueStr.split(',');
			}
			try {
				var clazz:Class = flash.utils.getDefinitionByName(type) as Class;
				if (clazz != null){
					value = new clazz(valueStr);
					if(flash.utils.getQualifiedClassName(value) == "Boolean") {
						value = parseBoolean(valueStr);
					}	
				}
				return value;
			} catch (e:ReferenceError) {
				trace("converToType ReferenceError. type:" + type + " valueStr:"+valueStr+" Error Message:" + e.message);
			} catch (e:Error){
				trace("converToType Error. type:" + type + " valueStr:"+valueStr+" Error Message:" + e.message);
			}
			
			switch(type.toLowerCase()) {
				case "number": value = parseNumber(valueStr);	break;
				case "boolean": value = parseBoolean(valueStr);	break;
				case "string": value = String(valueStr); 	break;
				case "pointer": value = "{"+valueStr+"}"; 	break;

			}
			return value;
		}	
		
		
		public static function myDeepCompare(obj1:*,obj2:*):Boolean {
			if (obj1 === obj2) {
				return true;
			} else if(flash.utils.getQualifiedClassName(obj1) != flash.utils.getQualifiedClassName(obj2)) {
				return false;
			} else if(flash.utils.getQualifiedClassName(obj1) == "Array") {
				if (obj1.length != obj2.length) {
					return false;
				} else {
					if (obj1.length != 0) {
						for (var i:int = 0;i<obj1.length;i++) {
							if (deepCompare(obj1[i],obj2[i]) == false) {
								return false
							}
						}
						return true;
					} else {
						for (var name:String in obj1) {
							if (deepCompare(obj1[name],obj2[name]) == false) {
								return false;
							}
						}
						return true;
					}
				}
			} else if(flash.utils.getQualifiedClassName(obj1) == "Object") {
				for (var n:String in obj1) {
					if (deepCompare(obj1[n],obj2[n]) == false) {
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
		
		public static function deepCompare(obj1:*,obj2:*):Boolean {
			var ba1:ByteArray = new ByteArray();
			ba1.writeObject(obj1);
			var ba2:ByteArray = new ByteArray();
			ba2.writeObject(obj2);
			return (ba1.toString()==ba2.toString());
		}
		
		
		public static function deepClone(obj:*):* {
			var ba1:ByteArray = new ByteArray();
			ba1.writeObject(obj);
			ba1.position = 0;
			return ba1.readObject();
		}
		
		
		public static function cloneType(obj:*):* {
			var value:*;
			var className:String;
			try {
				className = flash.utils.getQualifiedClassName(obj);
				if (className == "Array") {
					value = cloneArray(obj);
				} else if (className == "Object") {
					value = cloneObject(obj);
				} else {
					var clazz:Class = flash.utils.getDefinitionByName(className) as Class;
					if (clazz != null){
						value = new clazz(obj);
					}
				}
			} catch (e:ReferenceError) {
				trace("cloneType Error. type:" + className+ " obj:"+obj+" Error Message:" + e.message);
			} catch (e:Error){
				trace("cloneType general Error");
			}
			return value;
		}	
		
		
		public static function cloneArray(source:Object):*	{
		    var myBA:ByteArray = new ByteArray();
		    myBA.writeObject(source);
		    myBA.position = 0;
		    return(myBA.readObject());
		}
		
		
		public static function parseNumber(value:*):Number {
			if (typeof(value)=="string") return parseStringAsNumber(value);
			return Number(value);
		}
		
		
		public static function parseStringAsNumber(str:String):Number {
			var n:Number = Number(str);
			return n;
		}
		
		public static var numberChars:String = "0123456789.,eE-+";
		
		[Bindable]
		public static var NUMBER_RESTRICT:String = "-0123456789.,eE+";
		
		public static var emptySpaceChars:String = " \n\t\r";
		

		public static function cloneObject(x:*):* {
			var obj:Object = new Object();
			for (var element:* in x){
				obj[element] = x[element];
			}
			return obj;
		}
		
		
		public static function fetchObjectByTargetPath(root:Object,str:String):Object {
			var arr:Array = str.split('.');
			var target:Object = root;
			for (var i:int=0;i<arr.length;i++) {
				if(target.hasOwnProperty(arr[i])) {
					target = target[arr[i]];
				} else {
					return null;
				}
			}
			return(target);
		}
		
		
		public static function parseObjectPath(mcRoot:MovieClip, sTarget:String = null):Object {
			if (sTarget == null) {
				return null;
			} else {
				if (sTarget == "") {
					return mcRoot;
				} else {
					var aTarget:Array = sTarget.split(".");
					var sHead:String = String(aTarget.shift());
					return arguments.callee(mcRoot[sHead], aTarget.join("."));
				}
			}
		}
		
		
		public static function clearString(s_str:String = null):String {
			if (s_str == null) {
				return s_str;
			}
			var n_str:Array= new Array();
			for (var i:int=0;i<s_str.length;i++){
				var ch:String = s_str.charAt(i);
				if(ch != "\r" && ch != "\n" && ch != "\t") {
					n_str.push(s_str.charAt(i));
				}
			}
			return(n_str.join(''));
		}
		
		
		public static function parseXMLNodeToDotNotation(node:XMLNode):String {
			// analising fullName of target from xml node 
			var p:XMLNode = node;
			var arr:Array = new Array();
			while (p != null && p.attributes.label != undefined) {
				arr.push(p.attributes.label);
				p = p.parentNode;
			}
			var targetFullName:String = "";
			for (var i:int=arr.length-1;i>=0;i--) {
				targetFullName += arr[i] ;
				if (i != 0) { targetFullName+="."; }
			}
			return(targetFullName);
		}
		
		
		/**
		 * will convert:
		 * <CAPITree label="aelp>
		 * 	<CAPITeree label="platform>
		 * 		<CAPITree label="animation">
		 * 			<CAPITree label="angleControl>
		 * 				<state name="value type="Number/>
		 * 
		 * to aelp.platform.animation.angleControl.value
		 * 
		 * */
		public static function parseXMLToDotNotation(node:XML,attrName:String = "@label"):String {
			// analising fullName of target from xml node 
			var p:XML = node;
			var arr:Array = new Array();
			while (p != null && p[attrName] != null) {
				arr.push(p[attrName]);
				p = p.parent();
			}
			var targetFullName:String = "";
			for (var i:int=arr.length-1;i>=0;i--) {
				targetFullName += arr[i] ;
				if (i != 0) { targetFullName+="."; }
			}
			return(targetFullName);
		}
		
		
		public static function parseBoolean(b:*):Boolean {
			if (String(b).toLowerCase() == "true" || b == true) return(true);
			return(false);
		}
		
		
		public static function getQueryString():String {
			return ExternalInterface.call("window.location.href.toString");
		}
		
		
		public static function getQueryParameters():Object {
			var _params:Object = new Object();

			try {
				var _queryString:String = getQueryString();
				if(_queryString) {
				
					var params:Array = _queryString.split('?')[1].split('&');
					var length:uint = params.length;
					
					for (var i:uint=0,index:int=-1; i<length; i++) {
						var kvPair:String = params[i];
						if((index = kvPair.indexOf("=")) > 0) {
							var key:String = kvPair.substring(0,index);
							var value:String = kvPair.substring(index+1);
							_params[key] = value;
						}
					}
					
				}
			} catch(e:Error) { 
				trace("Some error occured. ExternalInterface doesn't work in Standalone player."); 
			}
			return _params;
		}
		
		
		
		public static function getCordsString(p:Point):String {
			var arr:Array = p.toString().split(',');
			
			var indexX:int = arr[0].indexOf('.');
			var strX:String = arr[0];
			var indexY:int = arr[1].indexOf('.');
			var strY:String = arr[1].slice(0,-1);
			
			if (indexX != -1) {
				strX = strX.substr(0, indexX+3);
				
				var subArrA:Array = strX.split('.');
				var tempA:String = subArrA[1].replace(/0/g,"");
				strX = subArrA[0]+'.'+tempA;
				trace (strX);
			}	
			
			if (indexY != -1) {
				strY = strY.substr(0, indexY+3);
				
				var subArrB:Array = strY.split('.');
				var tempB:String = subArrB[1].replace(/0/g,"");
				strY = subArrB[0]+'.'+tempB;
			}
			
			var joined:String = strX+','+strY+')';	
			
			return joined;
		}


	}

}