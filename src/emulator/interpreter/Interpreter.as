package emulator.interpreter
{
	import emulator.State;
	
	import flash.utils.Dictionary;
	
	
	public class Interpreter {
		public static const guardKeyword:String  = 'case';
		public static const helperKeyword:String = 'where';
		public static const pretestKeyword:String = 'whenever';
		public static const conditionTerminator:String = ':';
		public static const statementSeparator:String = ';';
		public static const instructionPartSeparator:String = ',';
		
		private var state:State;
		
		private var tokens:Array;
		private var acceptedToken:Token = null;
		private var pendingToken:Token;
		
		private var tokenPos:int = 0;
		
		private var where:Dictionary;
		
		public var internalAccessible:Boolean = false;
		
		public function Interpreter( tokens:Array, state:State, where:Dictionary ) {
			this.state = state;
			this.tokens = tokens;
			this.where = where;
			getToken();
		}
		
		private function getToken():void {
			if ( tokenPos != tokens.length ) {
				pendingToken = tokens[tokenPos];
				tokenPos++;
			} else {
				pendingToken = null;
			}
		}
		
		private function accept( tokenType:int ):Boolean {
			var accepted:Boolean = false;
			
			if ( pendingToken != null && pendingToken.type == tokenType ) {
				//trace( "[Interpreter.accept] tokenType: " + tokenType );
				//trace( "[Interpreter.accept] pendingToken: " + pendingToken.toString( ) );
				acceptedToken = pendingToken;
				getToken();
				accepted = true;
			}
			
			return accepted;	
		}
		
		private function expect( tokenType:int ):void {
			if ( !accept( tokenType ) ) {
				throw new InterpreterError( "Expected " + Token.typeString( tokenType ) + " but found " + pendingToken.typeToString() );
			}
		}
		
		private function validRegister( registerName:String ):Boolean {
			return (state.processor.registerNames.indexOf( registerName ) != -1);
		}
		
		
		
		/*
		 * Recursive Descent:
		 */
		
		private function bitExpression():int {
			var value:int = addExpression();
			
			while ( accept( Token.OpBitwise ) ) {
				switch ( acceptedToken.value ) {
					case "^": value ^= addExpression(); break;
					case "&": value &= addExpression(); break;
					case "|": value |= addExpression(); break;
					
					case ">>": value >>= addExpression(); break;
					case "<<": value <<= addExpression(); break;
					
					default: throw new InterpreterError( "Unknown bitwise operator: " + acceptedToken.value ); break;
				}
			}
			
			return value;
		}
		
		private function addExpression():int {
			var value:int = mulExpression();
			
			while ( accept( Token.OpTerm ) ) {
				switch ( acceptedToken.value ) {
					case "+": value += mulExpression(); break;
					case "-": value -= mulExpression(); break;
					
					default: throw InterpreterError( "Unknown additive operator: " + acceptedToken.value ); break;
				}
			}
			
			return value;
		}
		
		private function mulExpression():int {
			var value:int = unaryExpression();
			
			while ( accept( Token.OpFactor ) ) {
				switch ( acceptedToken.value ) {
					case "*": value *= unaryExpression(); break;
					case "/": value /= unaryExpression(); break;
					case "%": value %= unaryExpression(); break;
					
					default: throw InterpreterError( "Unknown multiplicative operator: " + acceptedToken.value ); break;
				}
			}
			
			return value;
		}
		
		private function unaryExpression():int {
			var isUnary:Boolean = accept( Token.OpUnary );

			var value:int = simpleExpression();
			
			if ( isUnary ) {
				switch ( acceptedToken.value ) {
					case "~": value = ~value; break;
					
					default: throw new InterpreterError( "Unknown unary operator: " + acceptedToken.value ); break;
				}
			}
			
			return value;
		}
		
		private function simpleExpression():int {
			var value:int;
			
			if ( accept( Token.GroupOpen ) ) {
				value = intExpression();
				expect( Token.GroupClose );
			} else if ( accept( Token.Integer ) ) {
				value = parseInt( acceptedToken.value );
			} else if ( accept( Token.Hex ) ) {
				value = parseInt( acceptedToken.value, 16 );
			} else if ( pendingToken.type == Token.RegisterName || pendingToken.type == Token.DerefOpen || pendingToken.type == Token.RegRefOpen ) {
				value = identifier();
			} else if ( pendingToken != null ) {
				throw new InterpreterError( "Unable to parse expression at: " + pendingToken.value );
			}
			
			return value;
		}
		
		private function identifier():int {
			var value:int;
			var registerName:String;
			
			if ( accept( Token.RegisterName ) ) {
				registerName = acceptedToken.value;
				
				if ( validRegister( registerName ) ) {
					value = state.getRegister( registerName );
				} else if ( where.hasOwnProperty( registerName ) ) {
					// lookup a 'where' clause value
					//trace( "WHERE" );
					value = Interpreter.interpretExpression( where[registerName], state, where );
				} else {
					throw new InterpreterError( "Unknown register or 'where' identifier: " + registerName );
				}
			} else if ( accept( Token.DerefOpen ) ) {
				var address:int = intExpression();
				
				expect( Token.DerefClose );
				
				value = state.getMemory( address );
			} else if ( accept( Token.RegRefOpen ) ) {
				var registerNumber:int = intExpression();
				
				expect( Token.RegRefClose );
				
				if ( registerNumber < state.processor.numRegisters ) {
					registerName = state.processor.registerNames[registerNumber];
					value = state.getRegister( registerName );
				} else {
					//trace( "[identifier] Out of bounds register reference" );
				}
			} else if ( accept( Token.Internal ) ) {
				if ( internalAccessible ) {
					switch ( acceptedToken.value ) {
						case "numBellRings": 
							value = state.numBellRings;
							break;
					
						case "numCycles": 
							value = state.executionStep;
							break;
						
						default:
							throw new InterpreterError( "Unknown integer internal value" );
							break;	
					}
				} else {
					throw new InterpreterError( "Internal information inaccessible" );
				}
			} else {
				throw new InterpreterError( "Unrecognised identifier: " + pendingToken.value );
			}
			
			//trace("[identifier] value: " + value.toString() );
			return value;
		}
		
		private function intExpression():int {
			return bitExpression();
		}
		
		private function stringComparison():Boolean {
			var value:Boolean;
			
			
			if ( internalAccessible ) {
				expect( Token.Internal );
			
				if ( acceptedToken.value != "output" ) {
					throw new InterpreterError( "Unknown internal string identifier: " + acceptedToken.value );
				} 
			
				expect( Token.OpComparison );
			
				if ( acceptedToken.value == "==" ) {
					expect( Token.StringLiteral );
					
					value = state.output == acceptedToken.value;
					
				} else if ( acceptedToken.value == "!=" ) {
					expect( Token.StringLiteral );
					
					value = state.output != acceptedToken.value;
					
				} else {
					throw new InterpreterError( "Unknown string comparison operator: " + acceptedToken.value );
				}
			} else {
				throw new InterpreterError( "Internal information inaccessible." );
			}
			
			return value;
		}

		private function boolExpression():Boolean {
			var value:Boolean;
			
			if ( accept( Token.BoolLiteral ) ) {
				switch ( acceptedToken.value ) {
					case "true":
					case "otherwise":
						value = true; break;
						
					case "false":
						value = false; break;
						
					default: throw new InterpreterError( "Unknown boolean literal: " + acceptedToken.value );
				}
			} else if ( accept( Token.GroupOpen ) ) {
				
				value = condition();
				
				expect( Token.GroupClose );
			} else if ( pendingToken.type == Token.Internal && pendingToken.value == "output" ) {
				
				value = stringComparison();
				
			} else {
				var leftSide:int = intExpression();
				
				expect( Token.OpComparison );
				var operator:String = acceptedToken.value;
				var rightSide:int = intExpression();
				
				switch ( operator ) {
					case ">": value = leftSide > rightSide; break;
					case "<": value = leftSide < rightSide; break;
					case ">=": value = leftSide >= rightSide; break;
					case "<=": value = leftSide <= rightSide; break;
					case "==": value = leftSide == rightSide; break;
					case "!=": value = leftSide != rightSide; break;
					
					default: throw new InterpreterError( "Unknown comparison operator: " + operator ); break;
				}
			}
			
			return value;
		}
		
		private function condition():Boolean {
			var value:Boolean = boolExpression();
			
			while ( accept( Token.OpLogic ) ) {
				switch ( acceptedToken.value ) {
					case "&&": value = value && boolExpression(); break;
					case "||": value = value || boolExpression(); break;
					
					default: throw new InterpreterError( "Unknown boolean operator: " + acceptedToken.value ); break;
				}
			}

			return value;
		}
		
		
		private function assignment( oldValue:int ):int {
			var newValue:int;
			
					
			if ( accept( Token.OpAssign ) ) {
				
				var tokenValue:String = acceptedToken.value;
				
				// Recurse
				newValue = intExpression();
				
				//trace( "[assignment] newValue: " + newValue );
				
				switch ( tokenValue ) {
					case "+=": newValue = oldValue + newValue; break;
					case "-=": newValue = oldValue - newValue; break;
					case "=" : break; // new value already set
					default: throw InterpreterError( "Unknown assignment operator: " + acceptedToken.value ); break;
				}
				
			} else if ( accept( Token.OpIncAssign ) ) {
				
				newValue = oldValue;
				
				switch ( acceptedToken.value ) {
					case "++": newValue++; break;
					case "--": newValue--; break;
					default: throw InterpreterError( "Unknown increment operator: " + acceptedToken.value ); break;
				}
				
			} else {
				throw new InterpreterError( "Unknown assignment operator: " + pendingToken.value );
			}
			return newValue;
		}
		
		private function statement():void {
			var value:int;
			
			if ( accept( Token.RegisterName ) ) {
				// register name assignment
				
				var registerName:String = acceptedToken.value;
				
				if ( validRegister( registerName ) ) {
					// recognised register name
					value = assignment( state.getRegister( registerName ) );
					state.setRegister( registerName, value );
					//trace( "[statement] set register " + registerName + " to " + value.toString() );
				} else {
					throw new InterpreterError( "Unknown register name: " + registerName );
				}
				
			} else if ( accept( Token.DerefOpen ) ) {
				// memory address assignment
				
				var memoryAddress:int = intExpression();
				
				expect( Token.DerefClose );
				
				value = assignment( state.getMemory( memoryAddress ) );
				state.setMemory( memoryAddress, value );
				
			} else if ( accept( Token.RegRefOpen ) ) {
				// register reference assignment
				
				var registerNumber:int = intExpression();
				
				expect( Token.RegRefClose );
				
				
				if ( registerNumber < state.processor.numRegisters ) {
					registerName = state.processor.registerNames[registerNumber];
					value = assignment( state.getRegister( registerName ) );
					state.setRegister( registerName, value );
				} else {
					//trace( "[statement] Out of bounds register reference" );
				}
				
			} else if ( accept( Token.Keyword ) ) {
				// command keyword
				
				var argumentValue:int;
				
				switch ( acceptedToken.value ) {
					case "print": {
						expect( Token.GroupOpen );
						argumentValue = intExpression();
						expect( Token.GroupClose );
						
						state.print( argumentValue );
					} break;
					
					case "printASCII": {
						// TODO: generalise into functionArguments function:
						expect( Token.GroupOpen );
						argumentValue = intExpression();
						expect( Token.GroupClose );
						
						state.printASCII( argumentValue );
					} break;
					
					case "bell": {
						state.ringBell();
					} break;
					
					case "halt": {
						state.halt();	
					} break;
					
					case "nop": {
						// twiddle thumbs	
					} break;
					
			
					default: {
						throw new InterpreterError( "Unknown command: " + acceptedToken.value );
					} break;
				}
				
			} else {
				throw new InterpreterError( "Unable to parse statement, register name, memory address or command not found." );
			}

		} 
		
		
		
		
		
		
		
		
		
		/*
		 * Interface
		 */
		static public function interpretStatement( statementTokens:Array, state:State, where:Dictionary ):void {
			var interpreter:Interpreter = new Interpreter( statementTokens, state, where );
			interpreter.statement();
		}
		
		static public function interpretCondition( conditionTokens:Array, state:State, where:Dictionary  ):Boolean {
			var interpreter:Interpreter = new Interpreter( conditionTokens, state, where );
			return interpreter.condition();
		}
		
		static public function interpretExpression( expressionTokens:Array, state:State, where:Dictionary  ):int {
			var interpreter:Interpreter = new Interpreter( expressionTokens, state, where );
			return interpreter.intExpression();
		}

	}
}




