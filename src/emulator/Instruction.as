package emulator
{
	public class Instruction {
		
		public var description:String;
		public var ipIncrement:int;
		
		public function Instruction( description:String, ipIncrement:int ) {
			this.description = description;
			this.ipIncrement = ipIncrement;
		}
		
		public function execute( state:State ):void {
			
		}

	}
}