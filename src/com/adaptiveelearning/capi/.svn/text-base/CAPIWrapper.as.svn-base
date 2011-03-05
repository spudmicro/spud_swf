package com.adaptiveelearning.capi {
	
	import mx.controls.Alert;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public dynamic class CAPIWrapper extends Proxy 	{
		
		public var CAPI:CAPIInterface2;
		public var targetObj:*;
		
		
		
		public function CAPIWrapper(targetObj:* = null,name:String = null, type:String = null) {
			super();
			CAPI = new CAPIInterface2(targetObj);
			CAPI.setCAPIProperty("name",name);
			CAPI.setCAPIProperty("type",type);
			
			this.targetObj = targetObj;
		}
		
		
		public function addCAPIState(name:String,type:String,inspectable:Boolean=false):void {
			CAPI.addCAPIState(name,type,inspectable);
		}
		
		
		public function setCAPIProperty(name:String,value:Object):void {
			CAPI.setCAPIProperty(name,value);
		}
		
		
		override flash_proxy function callProperty(methodName:*, ... args):* {
			try {
				var name:String  = methodName.localName;
				flash_proxy.setProperty(methodName, args);
			} catch(e:Error) {
				trace(e.message);
			}
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			try {
				targetObj[name.localName] = value;
			} catch (e:Error) {
				Alert.show(e.message); 
			}
		}
		
		override flash_proxy function getProperty(name:*):* {
			try {
				return targetObj[name];
			} catch (e:Error) {
				Alert.show(e.message); 
			}
			return null;
		}
		
		
		
		
	}
}