package  com.adaptiveelearning.capi {
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	[Event(name="loReady",type="flash.events.Event")]
	[Event(name="check",type="flash.events.Event")]
	
	public class CAPIInterface2 extends EventDispatcher {
		
		
		public static const LO_READY:String = "loReady";
		public static const WAIT_FOR_LO_READY:String = "waitForLoReady";
		public static const CHECK:String = "check";
		public static const SET_SESSION_DATA:String = "setSessionData";
		public static const GET_SESSION_DATA:String = "getSessionData";
		
		
		public var CAPIStatesArray:Array;
		public var CAPIObjectsArray:Array;  // of CAPIEntries
		public var CAPIPropertiesArray:Array;
		public var waitForLoReady:Boolean = false;
		
		public var root:Object; 
		
		public var version:int = 3; 
		
		
		public function CAPIInterface2(root:Object):void {
			this.root = root;
			CAPIStatesArray = new Array();
			CAPIObjectsArray = new Array();
			CAPIPropertiesArray = new Array();
		}
		
		
		public function addCAPIState(name:String,type:String,inspectable:Boolean,desc:CAPIDescription=null):void {
			var sEntry:CAPIStateEntry = new CAPIStateEntry();
			sEntry.name = name;
			sEntry.type = type;
			sEntry.inspectable = inspectable;
			sEntry.description = desc;
			 
			
			CAPIStatesArray.push(sEntry);
		}
		
		
		public function getCAPIState(name:String):CAPIStateEntry {
			for each (var entry:CAPIStateEntry in CAPIStatesArray) {
				if (entry.name == name) {
					return entry;
				}
			}
			return null;
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
		
		public function collectSnapshot():CAPISnapshot {
			var snapshot:CAPISnapshot = new CAPISnapshot();
			var i:int,t:int;
			t = CAPIStatesArray.length;
			
			// this object "states" 
			for (i=0;i<t;i++) {
				var name:String = CAPIStatesArray[i].name;
				var value:* = root[name];
				snapshot.setAttribute(name,value);
			}
			
			// add snapshots from sub objects by calling their own CAPI.getSnapshot
			// plus adding a prefix "name." to each returning subSnapshot 
			t = CAPIObjectsArray.length;
			for (i=0;i<t;i++) {
				var entry:CAPIObjectEntry = CAPIObjectsArray[i];
				if (entry.inspectable) {
					var targetObj:Object = getObjectFromEntry(entry);
					
					var subSnapshot:CAPISnapshot = targetObj.CAPI.collectSnapshot();
					var prefix:String = entry.name + "."
					
					subSnapshot.shiftAll(prefix);
					snapshot.merge(subSnapshot);
				}
			}
			//snapshot.shiftAll(this.getCAPIProperty('name')+".");
			return snapshot;
		}
		
		
		public function applySnapshot(snapshot:CAPISnapshot):void {
			for (var name:String in snapshot.attributesMap) {
				var value:* = snapshot.attributesMap[name];
				applyValue(name,value);
			}
		}
		
		
		public function applyValue(target:String,value:*):void {
			var nameParts:Array = target.split('.');
			
			var targetObject:Object
			
			var last:String = nameParts.pop();
			if (nameParts.length == 0) {
				targetObject = root;
			} else {
				var subTarget:String = nameParts.join('.');
			 	targetObject = fetchCAPIObject(subTarget);
			}
			targetObject[last] = value;
		}
		
		
		public function fetchCAPIObject(target:String):Object {
			var nameParts:Array = target.split('.');
			var entry:CAPIObjectEntry;
			
			if (nameParts.length ==1 ) {
				entry = objectNameMap[nameParts[0]];
				return getObjectFromEntry(entry);
			} 
			// else
			var firstName:String = nameParts.shift();
			for (var i:int = 0;i<CAPIObjectsArray.length;i++) {
				entry = CAPIObjectsArray[i];
				if (entry.name == firstName) {
					var subCAPI:CAPIInterface2 = getObjectFromEntry(entry).CAPI;
					return subCAPI.fetchCAPIObject(nameParts.join('.'));
				}
			}
			return null;
		}
		
		
		public function getObjectFromEntry(entry:CAPIObjectEntry):Object {
			var targetObj:Object;
			if (entry.parent !=null ) {
				targetObj = CAPIUtils.fetchObjectByTargetPath(entry.parent,entry.targetPath);
			} else {
				targetObj = entry.object;
			}
			return targetObj; 
		}
		
		
		public function addObject(name:String,object:Object,inspectable:Boolean = true):void {
			var entry:CAPIObjectEntry = new CAPIObjectEntry(name,object,null,null,inspectable);
			CAPIObjectsArray.push(entry);
			objectNameMap[name] = entry;
		}
		
		
		public function getEntryByObject(object:Object):CAPIObjectEntry {
			var t:int = CAPIObjectsArray.length;
			for (var i:int=0;i<t;i++) {
				var entry:CAPIObjectEntry = CAPIObjectsArray[i] as CAPIObjectEntry;
				if (entry.object === object){
					return entry;
				}
			}
			return null;
		}
		
		
		private var objectNameMap:Dictionary = new Dictionary();
		
		
		
		public function addDynamicObject(name:String,parent:Object,targetPath:String,inspectable:Boolean):void {
			var entry:CAPIObjectEntry = new CAPIObjectEntry(name,null,parent,targetPath,inspectable);
			CAPIObjectsArray.push(entry);
			objectNameMap[name] = entry;
		}
		
		
		
		public function setCAPIProperty(name:String,value:Object):void {
			CAPIPropertiesArray[name] = value;
		}
		
		
		public function getCAPIProperty(name:String):String {
			return CAPIPropertiesArray[name];
		}
		
		
		
		public function getCAPITree():XML {
			var name:String;
			var i:int,t:int;
			
			var capiTree:XML = new XML("<CAPITree />");
			for (name in CAPIPropertiesArray) {
				var value:Object = CAPIPropertiesArray[name];
				if (value != null && name != null) {
					capiTree.@[name] = value;
				}
			}
			
					
			var node:XML;
			
			for(i = 0; i<CAPIStatesArray.length;i++) {
				if (CAPIStatesArray[i] == undefined || CAPIStatesArray[i] == null) {
					continue;
				}
				node = CAPIStateEntry(CAPIStatesArray[i]).toXML();
								
				capiTree.appendChild(node);
			}
			
			t = CAPIObjectsArray.length;
			for (i=0;i<t;i++) {
				if (CAPIObjectsArray[i] == null) {
					continue;
				}
				var targetObj:Object;
				var entry:CAPIObjectEntry = CAPIObjectsArray[i];
				
				targetObj = getObjectFromEntry(entry);
								
				if (targetObj == null) {
					continue;
				}
				
				
				if(targetObj.hasOwnProperty("CAPI")) {
					node = targetObj.CAPI.getCAPITree();
					
					node.@name = entry.name;
										
					node.@inspectable = entry.inspectable;
					
					
					capiTree.appendChild(node);
				}
			}
			return (capiTree);
		}
		
	}
}