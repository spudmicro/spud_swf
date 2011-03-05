package com.adaptiveelearning.lo.utils {
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.ObjectUtil;
	
	
	
	public class UtilsMX {
		
		
		public static function getObjectProperties(obj:Object):Array {
			var pArray:Array = new Array();
			var info:Object = ObjectUtil.getClassInfo(obj);
			for each (var qn : QName in info.properties){
				pArray.push(qn.localName);
			}
			return pArray;
		}
		
		
		public static function objectToXml(obj : Object, name : String = null) : XML{
			var result : XML;
			
			if (obj is String) {
				return <String>{obj}</String>;
			} else if (obj is Number) {
				return <Number>{obj}</Number>;
			} else if (obj is Boolean) {
				return <Boolean>{obj}</Boolean>;
			}
			
			var info:Object = ObjectUtil.getClassInfo(obj);
			if(name==null) {
				name = info.name;
				name = name.replace('::','.');
			}
			result = new XML("<" + name + "></"+ name + ">");
			for each (var qn : QName in info.properties){
				var val : Object = obj[qn.toString()];
				if (val is Array || val is ArrayCollection) {
					var arrXML:XML = <{qn.toString()}/>;
					for (var i:int=0;i<val.length;i++) {
						arrXML.appendChild(objectToXml(val[i],null));
					}
					result.appendChild(arrXML);
				} else if(ObjectUtil.isSimple(val)) {
					result[qn.toString()] = val;
				} else {
					result.appendChild(objectToXml(val,qn.toString()));
				}
			}
			return result;			
		}
		
		
		public static function secondsToMinutes(secs:int):String {
			var df:DateFormatter = new DateFormatter();
			df.formatString = "NN:SS";
			var date:Date = new Date(null,0,0,0,0,0,0);
			date.setSeconds(secs,0);
			return df.format(date);
		}
		
		
		
		
		public static function xmlToObject(xml:XML):Object {
			trace(xml);
			
			trace(xml.localName())
			
			return new Object();
		}


	}
}