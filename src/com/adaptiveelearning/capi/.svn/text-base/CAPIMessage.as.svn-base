package com.adaptiveelearning.capi {
	
	import flash.events.EventDispatcher;
	
	[Event(name="snapshotReady",type="com.adaptiveelearning.capi.CAPIEvent")]
	[Event(name="applyStateComplete",type="com.adaptiveelearning.capi.CAPIEvent")]
	
	public class CAPIMessage extends EventDispatcher 	{
		
		public var capi:Object;
		public var snapshot:CAPISnapshot;
		
		public function CAPIMessage(capi:Object) 	{
			this.capi = capi;
			this.capi.addEventListener(CAPIEvent.SNAPSHOT_READY,onSnapshotReady)
		}
		
		public function onSnapshotReady(event:CAPIEvent):void {
			this.snapshot = event.snapshot;
			var capiEvent:CAPIEvent = new CAPIEvent(CAPIEvent.SNAPSHOT_READY);
			capiEvent.snapshot = this.snapshot;
			dispatchEvent(capiEvent);
		}
		
		
		public function collectSnapshot():void {
			var snapshot:CAPISnapshot = capi.collectSnapshot();
			var event:CAPIEvent = new CAPIEvent(CAPIEvent.SNAPSHOT_READY);
			event.snapshot = snapshot;
			dispatchEvent(event);
		}
		
		
		

	}
}