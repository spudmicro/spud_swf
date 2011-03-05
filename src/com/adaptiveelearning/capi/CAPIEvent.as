package com.adaptiveelearning.capi {
	
	import flash.events.Event;

	public class CAPIEvent extends Event 	{
		
		
		public static const SNAPSHOT_READY:String 			= "snapshotReady";
		public static const APPLY_STATE_COMPLETE:String		= "applyStateComplete";
		
		
		public var snapshot:CAPISnapshot;
		
		
		public function CAPIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
	}
}