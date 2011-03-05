package emulator
{
	public class State {
		
		private var memory:Array = new Array();
		private var registers:Array = new Array();
		
		// should all be getters-only
		public var isHalted:Boolean;
		public var output:String;
		public var numBellRings:int;
		
		public var pipelineStep:int;
		public var executionStep:int;
		
		public var processor:Processor;
		
		public function State( processor:Processor ) {
			this.processor = processor;
			this.reset();
		}
		
		public function duplicate( ):State {
			var newState:State = new State( this.processor );
			newState.setAllMemory( this.memory );
			newState.setAllRegisters( this.registers );
			
			newState.isHalted = this.isHalted;
			newState.output = this.output;
			newState.numBellRings = this.numBellRings;
			
			newState.pipelineStep = this.pipelineStep;
			newState.executionStep = this.executionStep;
			
			return newState;
		}
		
		public function reset( ):void {
			var i:int;
			for ( i = 0; i != processor.numMemoryAddresses; i++ ) {
				memory[i] = 0;
			}
			
			for ( i = 0; i != processor.numRegisters; i++ ) {
				registers[i] = 0;
			}
			
			isHalted = false;
			output = "";
			numBellRings = 0;
			pipelineStep = 0;
			executionStep = 0;
		}
		
		// ensure a value is within the allowed values of this processor
		private function constrainRegister( value:int ):int {
			var mask:uint = (1 << processor.registerBitSize)-1;
			return (value & mask);
		}
		private function constrainMemory( value:int ):int {
			var mask:uint = (1 << processor.memoryBitSize)-1;
			return (value & mask);
		}
		private function constrainAddress( value:int ):int {
			var newValue:int = value % processor.numMemoryAddresses;
			// wrap around negative addresses
			if ( newValue < 0 ) {
				newValue += processor.numMemoryAddresses; 
			}
			return newValue;
		}
		
		public function getRegister( registerName:String ):int {
			var registerIndex:int = processor.registerIndexLookup[registerName];
			return constrainRegister( registers[registerIndex] );
		}
		public function setRegister( registerName:String, value:int ):void {
			var registerIndex:int = processor.registerIndexLookup[registerName];
			registers[registerIndex] = constrainRegister( value );
		}
		
		public function getMemory( address:int ):int {
			address = constrainAddress( address );
			return constrainMemory( memory[address] );
		}
		public function setMemory( address:int, value:int ):void {
			address = constrainAddress( address );
			memory[address] = constrainMemory( value );
		}
		
		public function getAllMemory( ):Array {
			return new Array( memory );
		}
		public function setAllMemory( values:Array ):void {
			var i:int;
			for ( i = 0; i != processor.numMemoryAddresses; i++ ) {
				if ( i < values.length ) {
					memory[i] = constrainMemory( values[i] );
				} else {
					// set rest of memory to 0
					memory[i] = 0;
				}
			}
		}
		
		public function setAllRegisters( values:Array ):void {
			var i:int;
			for ( i = 0; i != processor.numRegisters; i++ ) {
				if ( i < values.length ) {
					registers[i] = constrainRegister( values[i] );
				} else {
					// set any unspecified registers to 0
					registers[i] = 0;
				}
			}
		}
		
		/*
		 * Side-Effects
		 */
		
		public function print( value:int ):void {
			output += value.toString();
		}
		 
		public function printASCII( value:int ):void {
		 	output += String.fromCharCode( value );
		}
		 
		public function ringBell( ):void {
		 	numBellRings++;
		}
		 
		public function halt( ):void {
		 	isHalted = true;
		}
		
		

	}
}