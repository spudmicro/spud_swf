package emulator
{
	import flash.utils.Dictionary;
	
	public class Processor {
		
		public var name:String;
		public var memoryBitSize:int;
		public var registerBitSize:int;
		public var numMemoryAddresses:int;
		
		private var _registerNames:Array;
		
		public var registerIndexLookup:Dictionary;
		
		public function get numRegisters( ):int {
			return _registerNames.length;
		}
		
		public function set registerNames( names:Array ):void {
			
			registerIndexLookup = new Dictionary( );
			
			this._registerNames = names;
			
			var hasIP:Boolean = false;
			var hasIS:Boolean = false;

			for ( var i:int = 0; i != names.length; i++ ) {
				
				var name:String = names[i];
				registerIndexLookup[name] = i;
				
				if ( name == "IP" ) {
					hasIP = true;
				} else if ( name == "IS" ) {
					hasIS = true;
				}
				
			}
			
			if ( !hasIP || !hasIS ) {
				throw new Error("Processor must have IP and IS registers");
			}
		}
		public function get registerNames( ):Array {
			return this._registerNames;
		}
		
		public var instructions:Array;
		public var pipeline:Array;
		
		public function Processor() {
			// mandatory registers
			registerNames = new Array( "IP", "IS" );
		}

	}
}