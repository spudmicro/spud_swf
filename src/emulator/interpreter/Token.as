package emulator.interpreter
{
	public class Token {
		public static const OpAssign:int 		= 0;
		public static const OpLogic:int			= 1;
		public static const OpComparison:int	= 2;
		public static const BoolLiteral:int		= 3;
		public static const GroupOpen:int		= 4;
		public static const GroupClose:int		= 5;
		public static const OpTerm:int			= 6;
		public static const OpFactor:int		= 7;
		public static const Integer:int			= 8;
		public static const Keyword:int			= 9;
		public static const RegisterName:int	= 10;
		public static const DerefOpen:int 		= 11;
		public static const DerefClose:int		= 12;
		public static const OpIncAssign:int		= 13;
		public static const OpBitwise:int		= 14;
		public static const OpUnary:int			= 15;
		public static const RegRefOpen:int 		= 16;
		public static const RegRefClose:int		= 17;
		public static const Hex:int				= 18;
		public static const Internal:int		= 19;
		public static const StringLiteral:int	= 20;
		
		public static function typeString( type:int ):String {
			var typeNames:Array = new Array(
				"assignment",
				"logical operator",
				"logical comparison",
				"boolean literal",
				"open group",
				"close group",
				"term operator",
				"factor operator",
				"integer",
				"keyword",
				"register name",
				"open dereference",
				"close dereference",
				"modifying assignment",
				"bitwise operator",
				"unary operator",
				"register reference open",
				"register reference close",
				"hex hash"
			);
			
			return typeNames[type];
		}
		
			
		public var value:String;
		public var type:int;
		
		public function toString():String {
			return "(" + Token.typeString( this.type ) + ", \"" + this.value + "\")";
		}
		
		public function typeToString():String {
			return Token.typeString( this.type );
		}
		
		public function Token( type:int, value:String ) {
			this.type = type;
			this.value = value;
		}
		
	}
}