package emulator.builtin
{
	import mx.controls.Alert;
	import emulator.*;
	
	public class Processor4917 extends FetchIncExecProcessor {
		public function Processor4917() {
			super();
						
			this.name = "4917";
			this.memoryBitSize = 4;
			this.numMemoryAddresses = 16;
			this.registerBitSize = 4;
			
			this.registerNames = new Array( "IP", "IS", "R0", "R1" );
			
			this.instructions = new Array (
				new BuiltinInstruction( "Halt",                       1, InstructionHalt ),
				new BuiltinInstruction( "Add (R0 = R0 + R1)",         1, InstructionAdd ),
				new BuiltinInstruction( "Subtract (R0 = R0 - R1)",    1, InstructionSubtract ),
				new BuiltinInstruction( "Increment R0 (R0 = R0 + 1)", 1, InstructionIncrementR0 ),
				new BuiltinInstruction( "Increment R1 (R1 = R1 + 1)", 1, InstructionIncrementR1 ),
				new BuiltinInstruction( "Decrement R0 (R0 = R0 - 1)", 1, InstructionDecrementR0 ),
				new BuiltinInstruction( "Decrement R1 (R1 = R1 - 1)", 1, InstructionDecrementR1 ),
				new BuiltinInstruction( "Ring Bell",                  1, InstructionRingBell ),
				
				new BuiltinInstruction( "Print <data> (numerical value is printed)", 2, InstructionPrint ),
				new BuiltinInstruction( "Load value at address <data> into R0",      2, InstructionLoadR0 ),
				new BuiltinInstruction( "Load value at address <data> into R1",      2, InstructionLoadR1 ),
				new BuiltinInstruction( "Store R0 into address <data>",              2, InstructionStoreR0 ),
				new BuiltinInstruction( "Store R1 into address <data>",              2, InstructionStoreR1 ),
				new BuiltinInstruction( "Jump to address <data>",                    2, InstructionJump ),
				new BuiltinInstruction( "Jump to address <data> if R0 == 0",         2, InstructionJumpIfR0is0 ),
				new BuiltinInstruction( "Jump to address <data> if R0 != 0",         2, InstructionJumpIfR0not0 )
			);
		}
		
		
		// Instruction Definitions for 4917
		
		public function InstructionHalt( state:State ):void {
			state.halt();
		}
		
		public function InstructionAdd( state:State ):void {
			var r0:int = state.getRegister( "R0" );
			var r1:int = state.getRegister( "R1" );
			
			state.setRegister( "R0", r0+r1 );
		}
		
		public function InstructionSubtract( state:State ):void {
			var r0:int = state.getRegister( "R0" );
			var r1:int = state.getRegister( "R1" );
			
			state.setRegister( "R0", r0-r1 );
		}
		
		public function InstructionIncrementR0( state:State ):void {
			var r0:int = state.getRegister( "R0" );

			state.setRegister( "R0", r0+1 );
		}

		public function InstructionIncrementR1( state:State ):void {
			var r1:int = state.getRegister( "R1" );

			state.setRegister( "R1", r1+1 );
		}
		
		public function InstructionDecrementR0( state:State ):void {
			var r0:int = state.getRegister( "R0" );

			state.setRegister( "R0", r0-1 );
		}

		public function InstructionDecrementR1( state:State ):void {
			var r1:int = state.getRegister( "R1" );

			state.setRegister( "R1", r1-1 );
		}
		
		public function InstructionRingBell( state:State ):void {
			state.ringBell( );
		}
		
		public function InstructionPrint( state:State ):void {
			var ip:int = state.getRegister( "IP" );
			var data:int = state.getMemory( ip-1 );
			state.print( data );
		}
		
		public function InstructionLoadR0( state:State ):void {
			var ip:int = state.getRegister( "IP" );
			var address:int = state.getMemory( ip-1 );
			
			state.setRegister( "R0", state.getMemory( address ) );
		}
		
		public function InstructionLoadR1( state:State ):void {
			var ip:int = state.getRegister( "IP" );
			var address:int = state.getMemory( ip-1 );
			
			state.setRegister( "R1", state.getMemory( address ) );
		}
		
		public function InstructionStoreR0( state:State ):void {
			var ip:int = state.getRegister( "IP" );
			var address:int = state.getMemory( ip-1 );
			
			state.setMemory( address, state.getRegister( "R0" ) );
		}
		
		public function InstructionStoreR1( state:State ):void {
			var ip:int = state.getRegister( "IP" );
			var address:int = state.getMemory( ip-1 );
			
			state.setMemory( address, state.getRegister( "R1" ) );
		}
	
		public function InstructionJump( state:State ):void {
			var ip:int = state.getRegister( "IP" );
			var address:int = state.getMemory( ip-1 );			
			
			state.setRegister( "IP", address );
		}		

		public function InstructionJumpIfR0is0( state:State ):void {
			if ( state.getRegister( "R0" ) == 0 ) {
				var ip:int = state.getRegister( "IP" );
				var address:int = state.getMemory( ip-1 );			
			
				state.setRegister( "IP", address );
			}
		}	
		
		public function InstructionJumpIfR0not0( state:State ):void {
			if ( state.getRegister( "R0" ) != 0 ) {
				var ip:int = state.getRegister( "IP" );
				var address:int = state.getMemory( ip-1 );			
			
				state.setRegister( "IP", address );
			}
		}
		
	}
}