package emulator.interpreter
{
	public class Tokeniser {
		
		private var tokens:Array;
		private var position:int;
		private var code:String;
		
		public function Tokeniser() {
		}
		
		
		private function addToken( type:int, value:String ):void {
			tokens.push( new Token( type, value ) );
			position += value.length;
		}
		
		private function throwError( message:String="" ):void {
			throw new InterpreterError( "unrecognised character at: " + code.charAt( position ) );
		}
		
		
		private function tokeniseComparison():void {
			var couplet:String = code.slice( position, position+2 );
			var char:String = code.charAt( position );
			
			if ( couplet == "<=" || couplet == ">=" || couplet == "!=" || couplet == "==" ) {
				addToken( Token.OpComparison, couplet );
			} else if ( char == "<" || char == ">" ) {
				addToken( Token.OpComparison, char );
			}
		}
		
		private function tokeniseEqualsSign():void {
			var couplet:String = code.slice( position, position+2 );
			
			if ( couplet == "==" ) {
				addToken( Token.OpComparison, couplet );
			} else {
				addToken( Token.OpAssign, "=" );
			}
		}
		
		private function tokeniseLogicOp():void {
			var couplet:String = code.slice( position, position+2 );
			var char:String = code.charAt( position );
			
			if ( couplet == "&&" || couplet == "||" ) {
				addToken( Token.OpLogic, couplet );
			} else {
				addToken( Token.OpBitwise, char );
			}
		}
		
		private function tokeniseBitshift():void {
			var couplet:String = code.slice( position, position+2 );
			
			if ( couplet == ">>" || couplet == "<<" ) { 
				addToken( Token.OpBitwise, couplet );
			} else {
				throw new InterpreterError( "Unknown operator: " + couplet );
			}
		}

		private function tokeniseAddOp():void {
			var couplet:String = code.slice( position, position+2 );
			var char:String = code.charAt( position );
			
			if ( couplet == "+=" || couplet == "-=" ) {
				addToken( Token.OpAssign, couplet );
			} else if ( couplet == "++" || couplet == "--" ) {
				addToken( Token.OpIncAssign, couplet );
			} else {
				addToken( Token.OpTerm, char );
			}
		}


		private function isDigit( char:String ):Boolean {
			return ( char >= "0" && char <= "9" );
		}
		
		private function isHexDigit( char:String ):Boolean {
			return ( isDigit( char ) || ( char >= "A" && char <= "F" ) );
		}
		
		private function isLetter( char:String ):Boolean {
			var lowerChar:String = char.toLowerCase();
			return ( char == "_" || (lowerChar >= "a" && lowerChar <= "z") );
		}
		
		private function isAlphanumeric( char:String ):Boolean {
			return ( isDigit( char ) || isLetter( char ) );
		}
		
		
		private function tokeniseInteger():void {
			var digitStr:String = "";
			var i:int = position;
			while ( i < code.length && isDigit( code.charAt( i ) ) ) {
				digitStr += code.charAt( i );
				i++;
			}
			
			addToken( Token.Integer, digitStr );
		}
		
		private function tokeniseHex():void {
			var digitStr:String = "";
			position++; // ignore leading #
			var i:int = position;
			while ( i < code.length && isHexDigit( code.charAt( i ) ) ) {
				digitStr += code.charAt( i );
				i++;
			}
			
			addToken( Token.Hex, digitStr );
		}
		
		private function arrayContains( array:Array, element:* ):Boolean {
			return ( array.indexOf( element ) != -1 );
		}
		
		private function tokeniseStringLiteral():void {
			var i:int = position;
			var stringVal:String = "";
			
			i++; // skip initial "
			while ( i < code.length && code.charAt( i ) != "\"" ) {
				// TODO: escape characters
				stringVal += code.charAt( i );
				i++;
			}
			
			addToken( Token.StringLiteral, stringVal );
			position += 2; // skip opening and closing quotes
			
		}
		
		private function tokeniseKeyword():void {
			var keywordStr:String = "";
			var i:int = position;
			while ( i < code.length && isAlphanumeric( code.charAt( i ) ) ) {
				keywordStr += code.charAt( i );
				i++;
			} 
	
			var booleanLiterals:Array = new Array (
				"true",
				"false",
				"otherwise"
			);
			
			var commands:Array = new Array (
				"print",
				"printASCII",
				"bell",
				"halt",
				"nop"
			);
			
			var internalKeywords:Array = new Array (
				"numBellRings",
				"output",
				"numCycles"
			);
			
			if ( arrayContains( booleanLiterals, keywordStr ) ) {
				addToken( Token.BoolLiteral, keywordStr );
			} else if ( arrayContains( commands, keywordStr ) ) {
				addToken( Token.Keyword, keywordStr );
			} else if ( arrayContains( internalKeywords, keywordStr ) ) {
				addToken( Token.Internal, keywordStr );
			} else {
				addToken( Token.RegisterName, keywordStr );		
			}
		}
		
		
		public function tokenise( code:String ):Array {
			this.code = code;
			
			tokens = new Array();
			
			var char:String;
			
			position = 0;
			while ( position != code.length ) {
				char = code.charAt( position );
				
				switch ( char ) {
					case "(": {
						addToken( Token.GroupOpen, char );
					} break;
					
					case ")": {
						addToken( Token.GroupClose, char );
					} break;
					
					case "[": {
						addToken( Token.DerefOpen, char );
					} break;
					
					case "]": {
						addToken( Token.DerefClose, char );
					} break;
					
					case "{": {
						addToken( Token.RegRefOpen, char );
					} break;
					
					case "}": {
						addToken( Token.RegRefClose, char );
					} break;
					
					case "*": 
					case "/":
					case "%": {
						addToken( Token.OpFactor, char );
					} break;
					
					case "~": {
						addToken( Token.OpUnary, char );
					} break;
					
					case "+": 
					case "-": {
						tokeniseAddOp();
					} break;
					
					case "<":
					case ">":
					case "!": {
						if ( code.charAt( position + 1 ) == char ) {
							// two of the same
							tokeniseBitshift();
						} else {
							tokeniseComparison();
						}
					} break;
					
					case "=": {
						tokeniseEqualsSign();
					} break;
					
					case "#": {
						tokeniseHex();
					} break;
					
					case "&":
					case "|":
					case "^": {
						tokeniseLogicOp();
					} break;
					
					case "\"": {
						tokeniseStringLiteral();
					} break;
					
					default: {
						if ( isDigit( char ) ) {
							tokeniseInteger();
						} else if ( isLetter( char ) ) {
							tokeniseKeyword();
						} else {
							throwError();
						}
					} break;
				}	
			}
			
			return tokens;
		}	
	}
}