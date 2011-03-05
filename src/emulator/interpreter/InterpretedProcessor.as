package emulator.interpreter
{
	import emulator.FetchIncExecProcessor;
	
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;

	public class InterpretedProcessor extends FetchIncExecProcessor {	
			
		public function InterpretedProcessor( definition:String ) {
			super();
			
			updateDefinition( definition );
		}
		
		private function removeWhitespace( code:String ):String {
			// replace one or more whitespace chars with a nothing
			return code.replace( /\s+/g, '' );
		}
		
		private function trim( str:String ):String {
			return str.replace( /^\s+/, '' ).replace( /\s+$/, '' );
		}
		
		private function isTitleLine( line:String ):Boolean {
			return ( trim( line ) != '' && trim( line ).charAt( 0 ) == '[');
		}
		
		private function addLineToDict( dict:Dictionary, line:String ):void {
			//trace( " InterpretedProcessor.addLineToDict" );
			//trace( "  trimmed line: " + trim( line ) );
			if ( trim( line ) != '' ) {
				
				var property:Array = line.split( ':' );
				var key:String = trim( property[0] );
				
				property = property.slice( 1, property.length );
				var value:String = trim( property.join( ':' ) );
				
				
				//trace( "  key: " + key + ", value: " + value );

				dict[key] = value;
			}
		}
		
		private function isDigit( char:String ):Boolean {
			return ( char >= "0" && char <= "9" );
		}
		
		private function extractHeader( code:String ):Array {
			var header:Array = new Array();
			var i:int;
			var start:int, end:int;
			
			i = 0;
			start = i;
			while ( i != code.length && code.charAt( i ) != Interpreter.instructionPartSeparator ) {
				i++;
			}
			
			end = i;
			header[0] = parseInt( code.substring( start, end ) );
			
			i++; // skip separator char
			start = i;
			while ( i != code.length && isDigit( code.charAt( i ) ) ) {
				i++;
			}
			
			end = i;
			header[1] = parseInt( code.substring( start, end ) );
			//trace( code.substring( start, end ) );
			
			return header;
		}
		
		private function extractCodeSection( code:String ):String {
			var codeStart:int;
			for ( codeStart = 0; codeStart != code.length; codeStart++ ) {
				// detect : or case statement
				if ( code.charAt( codeStart ) == Interpreter.conditionTerminator
					|| code.substr( codeStart, Interpreter.guardKeyword.length ) == Interpreter.guardKeyword ) {
					break;
				}
			}
			return code.substring( codeStart, code.length );
		}
		
		
		private function addInstructionCode( code:String, descriptions:Dictionary ):void {
			var instrNumStr:String;
			var instrNum:int;
			var ipInc:int;
			var instrCode:String;
			
			var headerParts:Array = extractHeader( code );
			instrNum = headerParts[0];
			instrNumStr = instrNum.toString();
			ipInc = headerParts[1];
			
			instrCode = extractCodeSection( code );
			/*
			trace( "[InterpretedProcessor.addInstructionCode] code: " + code );
			trace( "[InterpretedProcessor.addInstructionCode] instrNumStr: " + instrNumStr );
			trace( "[InterpretedProcessor.addInstructionCode] ipInc: " + ipInc );
			trace( "[InterpretedProcessor.addInstructionCode] instrCode: " + instrCode );
			*/
			this.instructions[ instrNum ] = new InterpretedInstruction( descriptions[instrNumStr], ipInc, instrCode );
		}
		
		public function updateDefinition( definition:String ):void {
			
			var properties:Dictionary = new Dictionary( );
			var descriptions:Dictionary = new Dictionary( );
			
			this.instructions = new Array( );
			
			var lines:Array = definition.split( '\n' );
			var lineNum:int = 0;
			
			while ( !isTitleLine( lines[lineNum] ) ) {
				// up until next [ ] heading
				
				addLineToDict( properties, lines[lineNum] );
				
				lineNum++;
			}
			// {{ lines[lineNum] starts with '[' }}
			
			this.name = properties['name'];
			this.memoryBitSize = parseInt( properties['memoryBitSize'] );
			this.numMemoryAddresses = parseInt( properties['numMemoryAddresses'] );
			this.registerBitSize = parseInt( properties['registerBitSize'] );
			
			var registerNames:Array = new Array( );
			
			for each ( var regName:String in properties['registerNames'].split( ',' ) ) {
				registerNames.push( trim( regName ) ); // order is important
			}
			
			this.registerNames = registerNames; // setter does verification
			
			// grab instruction descriptions
			if ( trim( lines[lineNum] ) == '[descriptions]' ) {
				lineNum++;
				
				while ( !isTitleLine( lines[lineNum] ) ) {
				// up until next [ ] heading
				
					addLineToDict( descriptions, lines[lineNum] );
				
					lineNum++;
				}
				
			} else {
				throw new InterpreterError( "Descriptions must be listed before instructions." );
			}
			
			if ( trim( lines[lineNum] ) == '[instructions]' ) {
				lineNum++;
				
				// code = all following lines without newlines
				// remove all text before start of instructions
				var code:String = lines.slice( lineNum, lines.length ).join( '' );
				code = removeWhitespace( code );
			} else {
				throw new InterpreterError( "No Instruction Set Defined" );
			}
			
			// splits each instruction definition
			var instructionDefinitions:Array = code.split( '.' );
			
			for each ( var instructionCode:String in instructionDefinitions ) {
				if ( instructionCode != "" ) {
					addInstructionCode( instructionCode, descriptions );
				}
			}
			
		}
		
	}
}