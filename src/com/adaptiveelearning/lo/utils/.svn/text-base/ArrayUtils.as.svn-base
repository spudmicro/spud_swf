package com.adaptiveelearning.lo.utils {
	public class ArrayUtils 	{
		

		public static function binarySearchPointByX(arr:Array,iMin:int,iMax:int,x:Number):MapEntry {
			if (iMax - iMin <= 1) {
				var d1:Number = Math.abs(arr[iMin].x - x);
				var d2:Number = Math.abs(arr[iMax].x - x);
				if (d1<d2) {
					return new MapEntry(iMin,arr[iMin]);
				} else{
					return new MapEntry(iMax,arr[iMax]);
				}
			} else {
				var mid:int = (iMax+iMin)/2;
				var val:Number = arr[mid].x;
				if (val==x) {
					return new MapEntry(mid,arr[mid]);
				} if (val<x) {
					return binarySearchPointByX(arr,mid,iMax,x);
				} else {
					return binarySearchPointByX(arr,iMin,mid,x);
				}
			}
		}
		
		
		
		public static function binarySearch(arr:Array,n:Number,iMin:int = -1,iMax:int = -1):int {
			if (iMin == -1) {
				iMin = 0;
				iMax = arr.length-1;
			}
			
			if (iMin == iMax-1) {
				var d1:Number = Math.abs(arr[iMin] - n);
				var d2:Number = Math.abs(arr[iMax] - n);
				if (d1<d2) {
					return iMin;
				} else{
					return iMax;
				}
			} else {
				var mid:int = (iMax+iMin)/2;
				var val:Number = arr[mid];
				if (val==n) {
					return mid
				} if (val<n) {
					return binarySearch(arr,n,mid,iMax);
				} else {
					return binarySearch(arr,n,iMin,mid);
				}
			}
		}
		
		
		public static function exclude(arr1:*,arr2:*):Array {
			var removed:Array = new Array();
			var total:int = arr2.length;
			var index:int;
			for (var i:int =0;i<total;i++) {
				index = arr1.indexOf(arr2[i]);
				if (index!=-1) {
					removed.push(arr1.splice(index,1));
				}
			}
			return removed;
		}
		
		
		
		public static function intersection(arr1:Array,arr2:Array):Array {
			var intersection:Array = new Array();
			var index:int;
			var total:int = arr2.length;
			for (var i:int = 0;i<total;i++) {
				index = arr1.indexOf(arr2[i]);
				if (index != -1){
					intersection.push(arr2[i]);
				}
			}
			
			return intersection;
		}
		
		
		
		/**
		 * Determines if the source array contains ONLY the values specified in the target array
		 * This is essentially comparing if the arrays are equal except that the order of the elements has no effect
		 * 
		 * @param arr1  Array of objects
		 * @param arr2  Array of objects
		 * Returns 
		 *   true if the source array contains only the values specified in the target array
		 */
		public static function arrayContainsOnly(arr1:Array,arr2:Array):Boolean {
			if (arr1 == null || arr2 == null || arr1.length != arr2.length) {
				return false;
			}
			
			
			var t1:Array = arr1.concat();
			var t2:Array = arr2.concat();
			var index:int = 1;
			var total:int = arr1.length;
			for (var i:int = 0; i < total; i++) {
				index = t2.indexOf(t1[i]); 
				if (index == -1) {
					return false;
				}
				else {
					t2 = t2.splice(index,1);
				}
			}
			
	
			return true;
		}
	}
}