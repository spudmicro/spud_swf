package emulator.interpreter
{
	public class InterpreterError extends Error {
		public function InterpreterError( message:String="", id:int=0 ) {
			super( message, id );
		}
		
		public static function assert( condition:Boolean, message:String ):void {
			if ( !condition ) {
				throw new InterpreterError( message );
			}
		}
		
	}
}