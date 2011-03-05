package com.adaptiveelearning.lo.capi {
	
	import com.adaptiveelearning.lo.utils.Utils;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	dynamic public class CAPIArrayWrapper extends Proxy 	{
				
		public var CAPI:CAPIInterface = new CAPIInterface();
		
		public var objectsType:String = "Object";
		
		public var insepectable:Boolean = true;
		
		public var startFromOne:Boolean = false;
		
		
		private var _targetArray:ArrayCollection;
		public function set targetArray(ac:ArrayCollection):void {
			if (_targetArray !=null && targetArray != ac) {
				_targetArray.removeEventListener(CollectionEvent.COLLECTION_CHANGE,updateCAPI);
			}
			_targetArray = ac;
			if (ac) {
				ac.addEventListener(CollectionEvent.COLLECTION_CHANGE,onCollectionChange);
				updateCAPI();
			}
			
		}
		
		
		public function onCollectionChange(event:CollectionEvent):void {
			updateCAPI();
		}
		
		
		public function updateCAPI():void {
			
			CAPI = new CAPIInterface();
			CAPI.setCAPIProperty("name",capiName);
			
			for (var i:int =0;i<targetArray.length;i++) {
				var targetName:String = (startFromOne == false) ? this.prefix+i : this.prefix+(i+1);
				try {
					var obj:Object = targetArray[i];
					if (overrideName) {
						obj.CAPI.setCAPIProperty("name",targetName);
					}
					CAPI.addObject(obj,insepectable);
				} catch(e:Error) {
					CAPI.addCAPIState(targetName,CAPIInterface.TYPE_OBJECT,insepectable);
				}
				
			}
		}
		
		 
		public function get targetArray():ArrayCollection {
			return _targetArray;
		}
		
		
		private var _prefix:String = "sha'asua";
		public function set prefix(str:String):void {
			_prefix = prefix;
		}
		public function get prefix():String { 
			return _prefix;
		} 
		
		
		public var overrideName:Boolean = true;
		
		
		
		private var _capiName:String;
		public function set capiName(str:String):void {
			_capiName = str;
			CAPI.setCAPIProperty("name",str);
		}
		public function get capiName():String {
			return _capiName;
		}
		
						
		public function CAPIArrayWrapper(name:String=null,prefix:String=null,targetArray:ArrayCollection = null,inspectable:Boolean = true, startFromOne:Boolean = false) {
			super();
			this.insepectable = inspectable;
			this.startFromOne = startFromOne;
			_capiName = name;
			_prefix = prefix;
			this.targetArray = targetArray;
		}
		
		
		override flash_proxy function getProperty(name:*):* {
			return doGetProperty(name);
		}
		
		
		public function doGetProperty(name:*):* {
			var length:int = prefix.length;
			var index:int = Number(name.localName.substring(length));  
			var actualIndex:int = (startFromOne == false) ? index : index -1;
			if (Utils.arrayHasIndex(targetArray,actualIndex)) {
				return targetArray[actualIndex];
			} else {
				return null;
			}
		}
		
	 	
		override flash_proxy function hasProperty(name:*):Boolean {
			var length:int = this.prefix.length;
			var index:int = Number(name.substring(length));  
			var actualIndex:int = (startFromOne == false) ? index : index -1;
			return (Utils.arrayHasIndex(targetArray,actualIndex));
		} 
		
		
		override flash_proxy function callProperty(name:*,... rest):* {	}
		 
		
     	override flash_proxy function nextNameIndex (index:int):int {
			return 0;
	    }
	    
	    
	    override flash_proxy function nextName(index:int):String {
		    return "totach ata.....flash proxy alek";
		}
		
		public function toString():String {
			return "[CAPIArrayWrapper]  targetArray:"+targetArray;
		}
	}
}