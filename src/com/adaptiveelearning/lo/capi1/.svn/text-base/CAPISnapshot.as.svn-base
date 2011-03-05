package com.adaptiveelearning.lo.capi { 
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias="com.adaptiveelearning.aelp.capi.CAPISnapshot")]
	public class CAPISnapshot	{
		
		
		public function CAPISnapshot() {
			attributesMap = new Object();
		}
		
		public var attributesMap:Object;
		
		
		public function getAttribute(key: String):* {
			return attributesMap[key];
		}
		
		/**
		 * Runs on all entries and perform string replace 
		 * e.g. : iRow.snapshot.replace("aelp.platform","aelp.stage");
		 * */
		
		public function replace(src:String,target:String):void {
			var nameArr:Array = getAttributesNames();
			var total:int = nameArr.length;
			var name:String;
			var value:*;
			for (var i:int = 0;i<total;i++) {
				name = nameArr[i];
				if (name.indexOf(src)!=-1) {
					value = attributesMap[name];
					delete attributesMap[name];
					name = name.replace(src,target);
					attributesMap[name] = value;
				}
			} 
		}
		
		
		public function removeAttribute(name:String):void {
			delete attributesMap[name]
		}
		
		
		public function setAttribute(key: String, value:*):void {
			attributesMap[key] = value;
		}
		
		
		
		public function getAttributesNames():Array {
			var arr:Array = new Array();
			for (var name:String in attributesMap) {
				arr.push(name);
			}
			return arr;
		}
		
		
		public function getNumAttributes():int {
			return getAttributesNames().length;
		}
		
		
		public function merge(snapshot:CAPISnapshot):CAPISnapshot {
			if (snapshot !=null) {
				for (var name:String in snapshot.attributesMap) {
					this.setAttribute(name,snapshot.attributesMap[name]);
				}
			}
			return this;
		}
		
		
		public function toText():String {
			var str:String = "";
			for (var name:String in attributesMap) {
				str += name + ": "+attributesMap[name] +"\n";
			}
			return str; 
		}
		
		
		// will add str to the begining name of all name values/
		// this is useful when we need to move animation.value to aelp.stage.animation.value
		public function shiftAll(str:String):void {
			var attrArray:Array = getAttributesNames();
			for each (var name:String in attrArray) {
				var value:* = this.getAttribute(name);
				removeAttribute(name);
				setAttribute(str + name,value);
			}
		}
		
		
		
		public function toNameValueArray():Array {
			var arr:Array = new Array();
			for (var name:String in attributesMap) {
				arr.push({name:name,value:attributesMap[name]});
			}
			return arr;
		}
		
		
		public function toNameValueArrayCollection():ArrayCollection{ 
			return new ArrayCollection(toNameValueArray());
		}
		
		
	}
}