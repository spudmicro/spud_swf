package emulator.builtin
{
	import emulator.*;
	public class BuiltinInstruction extends Instruction {
		private var func:Function;
		
		public function BuiltinInstruction( description:String, ipIncrement:int, func:Function ) {
			super( description, ipIncrement );
			this.func = func;
		}
		
		public override function execute( state:State ):void {
			func( state );
		}
		
	}
}