package emulator
{
	public class FetchIncExecProcessor extends Processor {
		public function FetchIncExecProcessor() {
			super();
			
			this.pipeline = new Array( fetch, increment, execute );
		}
		
		private function fetch( state:State ):void {
			// The instruction at the address given by IP is loaded into IS
			var ip:int = state.getRegister( "IP" );
			var instruction:int = state.getMemory( ip );
			state.setRegister( "IS", instruction );
		}
		
		private function increment( state:State ):void {
			var ip:int = state.getRegister( "IP" );
			var instructionNum:int = state.getRegister( "IS" );
			var instruction:Instruction = this.instructions[instructionNum];
			
			var ipIncrement:int;
			if ( instruction == null ) {
				ipIncrement = 1;
			} else {
				ipIncrement = instruction.ipIncrement;
			}
			
			state.setRegister( "IP", ip + ipIncrement );
		}
		
		private function execute( state:State ):void {
			var instructionNum:int = state.getRegister( "IS" );
			
			var instruction:Instruction = state.processor.instructions[instructionNum];
			
			if ( instruction != null ) {
				instruction.execute( state );
			} else {
				// be evil
			}
		}
		
	}
}