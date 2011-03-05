package com.adaptiveelearning.lo.utils {
	import flash.utils.Dictionary;
	
	
	public class Array2D { 
		
		public var table:Array = new Array();
		public var dict:Dictionary = new Dictionary();
		
		public var numRows:int = 0;
		public var numColumns:int = 0;
		
		public function Array2D() {
			
		}

		//Adds a row with a rowName associated with it
		public function addRow(rowName:String):void {
			//Adding the assigned index of the row to the dictionary
			dict[rowName] = numRows;
			
			//Adding the array row into the table
			table.push(new Array());
			
			numRows++;
		}
		
		
		//Retrieve information in the Row by the rowName
		public function getRowByName(rowName:String):Array {
			var arr:Array;
			var targetIndex:int = this.getIndexByRowName(rowName);
			if (!isNaN(targetIndex)) {
				arr = table[targetIndex]
				return arr;
			} else {
				var e:Error = new Error("Error in getRowByName: Cannot find "+rowName+" in dictionary");
				throw e;
			}
		}
		
		
		//Retrieves information of the Row by the rowIndex
		public function getRowByIndex(index:int):Array {
			var arr:Array = table[index];
			if (!arr) {
				return arr;
			} else {
				var e:Error = new Error("Error in getRowByIndex: Cannot find rowIndex "+index+" in the table");
				throw e;
			}
		}
		
		
		//Edits the current row selected by the rowIndex in the table 
		public function setRow(index:int, valuesArray:Array):void {
			var arr:Array = table[index];
			if (!arr) {
				table[index] = valuesArray;	
			} else {
				var e:Error = new Error("Error in setRow: Cannot find rowIndex "+index+" in the table");
				throw e;
			}
				
		}
		
		
		//Edits the current row selected by the rowName in the table
		public function setRowByName(rowName:String, valuesArray:Array):void {
			var targetIndex:int = this.getIndexByRowName(rowName);
			if (!isNaN(targetIndex)) {
				table[targetIndex] = valuesArray;
			} else {
				var e:Error = new Error("Error in setRowByName: Cannot find "+rowName+" in dictionary");
				throw e;
			}
		}
		
		
		//Deleted the row selected by the rowName in the table
		public function removeRowByName(rowName:String):void {
			var targetIndex:int = this.getIndexByRowName(rowName);
			if (!isNaN(targetIndex)) {
				//Remove rowName in the dictionary
				dict[rowName] = null;
				delete dict[rowName];
				
				//Remove values in the Array Row
				table.splice(targetIndex,1);
				numRows--;
				
				//Re-index the dictionary row;
				indexDictionary();
			} else {
				var e:Error = new Error("Error in removeRowByName: Cannot find "+rowName+" in dictionary");
				throw e;
			} 
		}
		
		
		//Deleted the row selected by the rowIndex in the table
		public function removeRow(index:int):void {
			var targetRowName:String = this.getRowNameByIndex(index);
			
			if (targetRowName) {
				//Delete the rowName in the dictionary
				dict[targetRowName] = null;
				delete dict[targetRowName];
				
				//Delete the values in the Array Row
				table.splice(index,1);
				numRows--;
				
				//Re-index the dictionary row;
				indexDictionary();
			} else {
				var e:Error = new Error("Error in removeRow: Cannot find rowIndex "+index+" in the table");
				throw e;				
			}
		}
		
		
		//Adds a column by providing a columnDictionary
		public function addColumnByDictionary(colDict:Dictionary):void {
			for (var rowName:Object in colDict) {
				if (dict[rowName] == undefined) {
					this.addRow(rowName as String);
				}
				
				var targetIndex:int = this.getIndexByRowName(rowName.toString());
				if (!isNaN(targetIndex)) {
					table[targetIndex].push(colDict[rowName]);
				} else {
					var e:Error = new Error("Error in addColumn: Cannot find "+rowName.toString()+" in dictionary");
					throw e;
				}
			}
			numColumns++;
		}
		
		
		//Adds a column by providing the valueArray
		public function addColumn(valueArray:Array):void {
			for (var i:int=0; i<numRows; i++) {
				table[i].push(valueArray[i]);
			}
			numColumns++;	
		}
		
		
		//Retrieves the column information in Dictionary form with the RowNames
		public function getColumnDictionary(index:int):Dictionary {
			var colDict:Dictionary = new Dictionary();
			for (var i:int=0; i<numRows; i++) {
				var rowName:String = this.getRowNameByIndex(i);
				colDict[rowName] = table[i][index];
			}
			return colDict;
		}
		
		
		//Retrieves column information array;
		public function getColumn(index:int):Array {
			var arr:Array = new Array();
			for (var i:int=0; i<numRows; i++) {
				arr.push(table[i][index]);
			}
			return arr;
		}
		
		
		//Edits the current column selected by a Dictionary associated with the rowNames
		public function setColumnByDictionary(index:int, colDict:Dictionary):void {
			for (var rowName:Object in colDict) {
				var targetIndex:int = this.getIndexByRowName(rowName as String);
				table[targetIndex][index] = colDict[rowName];
			}
		}
		
		
		//Edits the current column selected by an array in the table
		public function setColumn(index:int, valuesArray:Array):void {
			for (var i:int=0; i<numRows; i++) {
				table[i][index] = valuesArray[i];
			}
		}
		
		
		//Deletes the column data 
		public function removeColumn(index:int):void {
			for (var i:int=0; i<numRows; i++) {
				table[i].splice(index,1);
			}	
			numColumns--;
		}
		
		
		public function removeAll():void {
			table = new Array();
			dict = new Dictionary();
			numRows = 0;
			numColumns = 0;	
		}
		
		
		//Associates the rowName with the row index
		public function getRowNameByIndex(index:int):String {
			var str:String;
			for (var rowName:Object in dict) {
				if (dict[rowName] == index) {
					str = rowName.toString();
				}	
			}
			return str;
		}
		
		
		//Associates the index of the row with the rowName
		public function getIndexByRowName(rowName:String):int {
			return dict[rowName];
		}
		
		
		//Refreshes the index of the dictionary. Used when a row is deleted in the table
		public function indexDictionary():void {
			var i:int = 0;
			for (var rowName:String in dict) {
				dict[rowName] = i;
				i++
			}	
		}
		
		
		
		
	}
}