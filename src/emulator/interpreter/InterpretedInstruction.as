package emulator.interpreter
{
	import emulator.Instruction;
	import emulator.State;
	
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;

	public class InterpretedInstruction extends Instruction {
		private var conditions:Array;
		private var where:Dictionary;
		private var tokeniser:Tokeniser = new Tokeniser();
		
		public function InterpretedInstruction( description:String, ipIncrement:int, code:String ) {
			super( description, ipIncrement );
			updateCode( code );
		}
		
		private function removeWhitespace( code:String ):String {
			// replace one or more whitespace chars with a nothing
			return code.replace( /\s+/g, '' );
		}
		
		private function addCondition( conditionCode:String, statements:String, continuation:Boolean ):void {
			
			
			var conditionObj:Object;
			
			conditionObj = new Object( );
			conditionObj['condition'] = tokeniser.tokenise( conditionCode );
			conditionObj['statements'] = new Array( );
			conditionObj['continuation'] = continuation;
			
			//trace( conditionCode );
			//trace( statements );
			
			for each ( var statement:String in statements.split( Interpreter.statementSeparator ) ) {
				conditionObj['statements'].push( tokeniser.tokenise( statement ) );
			}
			
			//trace( "[addCondition] tokenised as: " );
			//trace( conditionObj['statements'] );
			conditions.push( conditionObj );
		}
		
		public function updateCode( code:String ):void {
			// { code = characters after number, increment defn }
			
			code = removeWhitespace( code );
			conditions = new Array( );
			
			// try/catch (non-trusted data)
			
			var startingSymbol:String = code.charAt( 0 );
			
			// detect and remove starting symbol
			if ( startingSymbol == Interpreter.guardKeyword.charAt( 0 ) ) {
				InterpreterError.assert( code.substr( 0, Interpreter.guardKeyword.length ) == Interpreter.guardKeyword, "Invalid symbol after instruction header" );
				code = code.slice( Interpreter.guardKeyword.length, code.length );
				startingSymbol = Interpreter.guardKeyword;
			} else {
				code = code.slice( 1, code.length );
			}
			
			//trace( "[updateCode] startingSymbol: " + startingSymbol );
			//trace( "[updateCode] code: " + code );
			
			
			//trace( "[updateCode] Building Tokens for '" + startingSymbol + "': " );
			
			// extract helper clause
			var parts:Array = code.split( Interpreter.helperKeyword );
			code = parts[0];
			
			//trace( "[updateCode] parts" + parts.toString() );
			
			if ( parts.length > 1 ) {
				// parse helper clause
				InterpreterError.assert( parts.length == 2, "Only one '" + Interpreter.helperKeyword + "' allowed" );
				
				var whereClause:String = parts[1];
				
				var whereStatements:Array = whereClause.split( Interpreter.statementSeparator );
				
				where = new Dictionary();
				for each ( var whereStatement:String in whereStatements ) {
					
					if ( whereStatement != '' ) {
						
						var statementParts:Array = whereStatement.split( '=' );
					
						InterpreterError.assert( statementParts.length == 2, "assignment required" );
					
						var key:String = statementParts[0];
						var expressionValue:String = statementParts[1];
					
						where[key] = tokeniser.tokenise( expressionValue );
					}
				}
			}
			
			if ( startingSymbol == Interpreter.conditionTerminator ) {
				// is a single command
				
				//trace( "[updateCode] Single Instruction" );
				addCondition( 'true', code, false );
			} else if ( startingSymbol == Interpreter.guardKeyword ) {
				// is a conditional command
				//trace( "[updateCode] Conditional Instruction" );
				// split code into condition blocks
				var chunks:Array = code.split( Interpreter.guardKeyword );
				
				//trace( chunks );
				
				for ( var i:int = 0; i != chunks.length; i++ ) {
					
					// split condition blocks into condition and program
					var subChunks:Array = chunks[i].split( Interpreter.conditionTerminator );
					var continuation:Boolean = false;
					
					// fallthrough dodgy conditions
					if ( subChunks.length == 1 ) {
						subChunks = chunks[i].split( '?' );
						continuation = true;
					}
					
					var condition:String = subChunks[0];
					var program:String = subChunks[1];
					
					if ( condition != '' ) {
						addCondition( condition, program, continuation );
					}
				}	
			}
			
			
		}
		
		public override function execute( state:State ):void {
			
			for each ( var conditionObj:Object in conditions ) {
				try {
					var conditionValue:Boolean = Interpreter.interpretCondition( conditionObj['condition'], state, where );
					
					if ( conditionValue ) {
						
						//trace( "EXECUTING: " + conditionObj['statements'] );
						for each ( var statement:Array in conditionObj['statements'] ) {
							//trace( "  * " + statement );
							Interpreter.interpretStatement( statement, state, where );
						}
						
						// escape after a true condition
						if ( !conditionObj['continuation'] ) {
							break;
						}
					}
					
				} catch ( interpreterError:InterpreterError ) {
					Alert.show( "Parsing Error: " + interpreterError.message );
				}
			}
		}
		
	}
}