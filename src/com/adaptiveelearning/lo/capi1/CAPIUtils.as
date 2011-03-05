package com.adaptiveelearning.lo.capi {
	
	
	public class CAPIUtils 	{
		
		
		/**
		 * 
		 */ 
		public static function collectSnapshot(root:Object,capiTree:XML):CAPISnapshot {
			var obj:Object = new Object();
			collectSnapshotObject(root,capiTree,obj);
			
			var snapshot:CAPISnapshot = new CAPISnapshot();
			for (var name:String in obj) {
				snapshot.setAttribute(name,obj[name]);
			}
			return snapshot;
		}
		
		
		public static function collectSnapshotObject(root:Object,curNode:XML,obj:Object):void {
			if (curNode.@inspectable == "false") {  // we exit if the object is not inspectable
				return;
			}
			
			if (curNode.children().length() == 0 ) { // if leaf
				if(parseBoolean(curNode.@inspectable)) {
					var target:String = parseXMLToDotNotation(curNode,"@name");
					var value:Object = fetchObjectByTargetPath(root,target);
					if(value==null) {
						//return;
					}
					obj[target] = value;
				} 
			}
			else { 	// else iterate 
				for(var i:int=0;i<curNode.children().length();i++){
					collectSnapshotObject(root,curNode.children()[i],obj);
				}
			}
		}
		
		
		public static function capiItemToToolTip(item:Object):String {
			if (item == null) {
				return "";
			}
			var dataTip:String= item.@name+" : "+item.@type;
				
			var enums:String = item.@enumeration;
			if (enums!=null && enums!="") {
				dataTip +="\nPossible values: "+enums;
			}
			
			var desc:String = item.@description;
			if (desc!="" && desc != null) {
				dataTip +="\n\n"+item.@description;
			}
			return dataTip;
		}
		
		
		public static function parseBoolean(b:*):Boolean {
			if (String(b).toLowerCase() == "true" || b == true) return(true);
			return(false);
		}
			
		
		/**
		 * e.g. root = animation str = "myObj.someSubObj.propertyName"
		 * */
		
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
		

	}
}