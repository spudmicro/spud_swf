package com.adaptiveelearning.capi {
	import mx.utils.ObjectUtil;
	
	
	
	[RemoteClass(alias="com.adaptiveelearning.aelp.capi.CAPIStateEntry")]
	public class CAPIStateEntry  {
		
		public var name:String;
		public var type:String;
		public var inspectable:Boolean;
		public var description:CAPIDescription; 

		public function CAPIStateEntry()	{
		}
		
		
		public function toDataTip():String {
			var dataTip:String = this.name + " : "+this.type;
			
			if (description!=null ) {	
				if (description.enumeration!=null && description.enumeration.length>0) {
					dataTip +="\nPossible values: "+description.enumeration;
				}
			
				if (description.description != null && description.description != "") {
					dataTip +="\n\n"+description.description;
				}
			}
			return dataTip;
		}
		
		
		public function toXML():XML {
			var node:XML = <CAPIState/>
			
			node.@name=  name;
			node.@type = type; 
			node.@inspectable = inspectable;
			
			if (description) {
				if (description.description) {
					node.@description = description.description;
				}
				if (description.enumeration) {
					node.@enumeration = description.enumeration.toString();
				}
				
				node.@read = description.read;
				node.@write = description.write;
				node.@asynch = description.asynch;
			}
			return node;
		}
		
		public static function fromXML(xml:XML):CAPIStateEntry {
			var entry:CAPIStateEntry = new CAPIStateEntry();
			entry.description = new CAPIDescription();
			entry.name = xml.@name;
			entry.type = xml.@type;
			entry.inspectable = parseBoolean(xml.@inspectable);
			entry.description.read = parseBoolean(xml.@read);
			entry.description.write = parseBoolean(xml.@write);
			entry.description.asynch = parseBoolean(xml.@asynch);
			entry.description.description = xml.@description;
			entry.description.enumeration = String(xml.@enumeration).split(',');
			
			return entry;
		}
		
		public static function parseBoolean(b:*):Boolean {
			if (String(b).toLowerCase() == "true" || b == true) return(true);
			return(false);
		}
		
		
		public function clone():CAPIStateEntry {
			
			var obj:* = ObjectUtil.copy(this) as CAPIStateEntry;
			if (obj ==null) {
				throw new Error("CAPIStateEntry won't clone'. you might need to call flash.net.registerClassAlias('com.adaptiveelearning.aelp.capi.CAPIStateEntry',CAPIStateEntry); somewhere in your code"); 
			} 
			return obj;
		}

	}
} 