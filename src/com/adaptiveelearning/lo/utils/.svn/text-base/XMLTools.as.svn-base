package com.adaptiveelearning.lo.utils {
	
	public class XMLTools {
		
		private var XMLPacket:String;
		
		// the constructor
		public function XMLTools() {}
	
		public function toXML(object2Convert:Object):String
		{
			XMLPacket="";
			loopObject(object2Convert);
			return XMLPacket;
			trace("here it is: " + XMLPacket);
		}
	
		private function loopObject(object2Convert:Object, arrayName:String = null):String
		{
			// is this Object an Array?  If so, we must handle differently
			if(object2Convert instanceof Array)
			{
				// walk the array
				for(var i=0; i < object2Convert.length; i++)
				{
					switch(true)
					{
						case(object2Convert[i] instanceof Object):
							// this arrayName is passed from below.  I need it to know the opening and closing tag names
							XMLPacket=XMLPacket + "<" + arrayName + ">";
							loopObject(object2Convert[i]);
							XMLPacket=XMLPacket + "</" + arrayName + ">";
							break;
						default:
							trace("|-- ERROR: SHOULD NOT GO HERE.");
					}	
				}
			// OK it is not an array.  lets run it through a switch.
			} else {
				// ok run through the Object	
				for(var i in object2Convert)
				{
					switch(true)
					{
					// again check for an array.  they are sneaky this way
					case(object2Convert[i] instanceof Array):
						loopObject(object2Convert[i], i);
						break;
					// if it is an object then run through that
					case(object2Convert[i] instanceof Object):
						// this is the opening tag
						XMLPacket=XMLPacket + "<" + i + ">";
							// ** this is an issue for me.  Sometimes the value of a parameter is viewed as an Object.  SO I toString() it to see.
							if (object2Convert[i].toString() == "[object Object]")
							{
								loopObject(object2Convert[i]);
							} else {
								XMLPacket=XMLPacket + "<![CDATA[" + object2Convert[i] + "]" + "]>";
							}
						// this is the closing tag...hehe I could not resist
						XMLPacket=XMLPacket + "</" + i + ">";
						break;
					default:
						// for the rest do this....means they are not showing up as Arrays or Objects
						XMLPacket=XMLPacket + "<" + i + ">";
						XMLPacket=XMLPacket + "<![CDATA[" + object2Convert[i] + "]" + "]>";
						XMLPacket=XMLPacket + "</" + i + ">";
					}
				}
			}
			// return the final XML String
			return XMLPacket;
		}
		
	}
}