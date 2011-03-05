package com.adaptiveelearning.lo.capi {
	
	import com.adaptiveelearning.lo.utils.Utils;
	
	import flash.events.EventDispatcher;
	
	[Event(name="loReady",type="flash.events.Event")]
	[Event(name="check",type="flash.events.Event")]
	
	public class CAPIInterface extends EventDispatcher {
		
		
		public static const LO_READY:String = "loReady";
		public static const WAIT_FOR_LO_READY:String = "waitForLOReady";
		public static const CHECK:String = "check";
		public static const SET_SESSION_DATA:String = "setSessionData";
		public static const GET_SESSION_DATA:String = "getSessionData";
		
		
		public var CAPIStatesArray:Array;
		public var CAPIObjectsArray:Array;
		public var CAPIPropertiesArray:Array;
		public var waitForLoReady:Boolean = false;
		
		public var version:int = 2; // 2nd version capi's dispatch appReady when app is ready 
		
		static public const TYPE_BOOLEAN:String = "Boolean";
		static public const TYPE_NUMBER:String = "Number";
		static public const TYPE_OBJECT:String = "Object";
		static public const TYPE_FUNCTION:String = "Function";
		static public const TYPE_STRING:String = "String";
		static public const TYPE_ARRAY:String = "Array";
		static public const TYPE_NUMBER_UNITS:String = "NumberUnits";
		static public const TYPE_CUSTOM:String = "Custom";
		
		
		
		
		public function CAPIInterface():void {
			CAPIStatesArray = new Array();
			CAPIObjectsArray = new Array();
			CAPIPropertiesArray = new Array();
		}
		
		
		public function addCAPIState(name:String,type:String,inspectable:Boolean = false,...args):void {
			var obj:Object = new Object();
			obj.name = name;
			obj.type = type;
			obj.inspectable = inspectable;
			for (var name:String in args[0]) {
				obj[name] = args[0][name];
			}
			CAPIStatesArray.push(obj);
		}
		
		
		public function removeCAPIState(name:String):void {
			for (var i:int=0;i<CAPIStatesArray.length;i++) {
				if (CAPIStatesArray[i].name == name) {
					CAPIStatesArray.splice(i,1);
					i--;
				}
			}
		}
		
		
		public function removeObject(obj:Object):void {
			for (var i:int=0;i<CAPIObjectsArray.length;i++) {
				if (CAPIObjectsArray[i] == obj) {
					CAPIObjectsArray.splice(i,1);
					i--;
				}
			}
		}
		
		
		public function removeDynamicObject(obj:Object,obj2:Object = null):void {
			for (var i:int=0;i<CAPIObjectsArray.length;i++) {
				if (CAPIObjectsArray[i].parent == obj && CAPIObjectsArray[i].name == obj2) {
					CAPIObjectsArray.splice(i,1);
					i--;
				}
			}
		}
		
		
		
		public function addObject(obj:Object,inspectable:Boolean):void {
			if(obj != null) {
				CAPIObjectsArray.push({object:obj,inspectable:inspectable});
			}
		}
		
		
		
		public function addDynamicObject(parent:Object,name:String,inspectable:Boolean):void {
			CAPIObjectsArray.push({parent:parent,name:name,inspectable:inspectable});
		}
		
		
		
		public function setCAPIProperty(name:String,value:Object):void {
			CAPIPropertiesArray[name] = value;
		}
		
		
		public function getCAPIProperty(name:String):String {
			return CAPIPropertiesArray[name];
		}
		
		
		public function addDynamicObjectAs(parent:Object,targetPath:String,alias:String,inspectable:Boolean):void {
			CAPIObjectsArray.push({parent:parent,name:targetPath,alias:alias,inspectable:inspectable});
		}
	
		
		private var _capiTree:XML;
		
		public function getCAPITree():XML {
			if (this.getCAPIProperty("rebuild") == "false" && _capiTree!=null) {
				return _capiTree;
			}
			var name:String;
			
			var capiTree:XML = new XML("<CAPITree />");
			for (name in CAPIPropertiesArray) {
				var value:Object = CAPIPropertiesArray[name];
				if (value != null && name != null) {
					capiTree.@[name] = value;
				}
			}
			
			if (capiTree.@name != null) {
				capiTree.@label = capiTree.@name;
			}
		
			
			var node:XML;
			var i:Number;
			
			for(i = 0; i<CAPIStatesArray.length;i++) {
				if (CAPIStatesArray[i] == undefined || CAPIStatesArray[i] == null) {
					continue;
				}
				node = <state/>
				for (name in CAPIStatesArray[i]) {
					node["@"+name] = CAPIStatesArray[i][name];
				}
				node.@label = node.@name;
				
				if ( CAPIStatesArray[i].inspectable == true ) {
					node.@inspectable = CAPIStatesArray[i].inspectable;
				}
				capiTree.appendChild(node);
			}
			
			for (i=0;i<CAPIObjectsArray.length;i++) {
				if (CAPIObjectsArray[i] == null) {
					continue;
				}
				var targetObj:Object;
				var capiObj:Object = CAPIObjectsArray[i];
				
				if (capiObj.hasOwnProperty("parent")) { // was added as dynamic object and saved as  {parent:parent,name:name,inspectable:inspectable}
					// name might contain '.' so we need to try get target (e.g. addDynamicObject(this,"questionPanel.inputPanel.curInputPanel",true);
					targetObj = Utils.fetchObjectByTargetPath(capiObj.parent,capiObj.name);
					/* targetObj = capiObj.parent[capiObj.name]; */
				} else {
					targetObj = capiObj.object;
				}
				
				if (targetObj == null) {
					continue;
				}
				
				
				if(targetObj.hasOwnProperty("CAPI")) {
					node = targetObj.CAPI.getCAPITree();
					
					if (capiObj.hasOwnProperty("alias")) {
						node.@name = capiObj.alias;
					}
					
					if (capiObj.hasOwnProperty("inspectable")) {
						node.@inspectable = capiObj.inspectable;
					} else {
						node.@inspectable = true;
					}
					
					capiTree.appendChild(node);
				}
			}
			_capiTree = capiTree
			return _capiTree;
		}
		
	}
}