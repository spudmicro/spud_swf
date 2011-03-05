package com.adaptiveelearning.capi {
	import com.adaptiveelearning.aelp.kModel.ApplyState;
	
	
	public interface ICAPIInterface {
		
		function collectSnapshot():void;
		function applySnapshot(snapshot:CAPISnapshot,callback_Handler:Function):void;
	
	}
}