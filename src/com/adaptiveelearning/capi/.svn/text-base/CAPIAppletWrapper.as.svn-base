package com.adaptiveelearning.capi {

	import flash.external.ExternalInterface;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public dynamic class CAPIAppletWrapper extends Proxy {
		
		
		
		public function CAPIAppletWrapper()	{
			super();
		}
		
		
		private var appletTargetPath:String;
		public function init(iframeID:String,appletID:String):void {
			this.appletTargetPath = "document.getElementById('"+iframeID+"').contentDocument." + appletID;
		}
		
		
		override flash_proxy function setProperty(name:*, value:*):void {
			try {
				//targetObj[name] = value;
			} catch (e:Error) {
				//Alert.show(e.message); 
			}
		}
		
		
		override flash_proxy function callProperty(name:*,...rest):* {
			var str:String = appletTargetPath + "." +name.localName;
			 
			if(rest.length ==0) {
				str = str+"();"
			} else {
				str = str+"("+rest+");"
			} 
			str = "function(){return "+str+"}";
			trace(str);
			return ExternalInterface.call(str);
		}
		
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return true;
		} 
		
		 
		
     	override flash_proxy function nextNameIndex (index:int):int {
			return 0;
	    }
		
	}
}