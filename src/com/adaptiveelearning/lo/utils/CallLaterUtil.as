package com.adaptiveelearning.lo.utils {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class CallLaterUtil extends EventDispatcher {
	

		private var _methodTable:Array = new Array();
		private var waitingStack:Array = new Array();
		protected var stage:DisplayObject;
		
		public function CallLaterUtil(stage:DisplayObject) {
			this.stage = stage;

		}
		
		
		
		public function doLater(callbackThisObj:Object, fn:*,args:Array):void {
			if (_methodTable == null) {
				_methodTable = new Array();
			}
			_methodTable.push({obj:callbackThisObj, fn:fn,args:args});
			
			setFrameTimer();
		}
		
		
		private function setFrameTimer():void {
			stage.addEventListener(Event.ENTER_FRAME,doLaterDispatcher);
		}
		
	
	
		// callback that then calls queued functions
		private function doLaterDispatcher(event:Event = null):void {	
			//trace("|CallLaterUtil>frame");
			// go on waitingStack reducing frame counts and see if there are methods to be added now:
			for (var i:Number = 0;i<waitingStack.length;i++) {
				var laterCallObj:Object = waitingStack[i];
				laterCallObj.frames --;
				if (laterCallObj.frames <= 0) {
					waitingStack.splice(i,1);
					i--;
					_methodTable.push(laterCallObj);
				}
			}
			
			// make a copy of the __methodtable so methods called can requeue themselves w/o putting
			// us in an infinite loop
			var __methodTable__:Array = _methodTable;
			// new doLater calls will be pushed here
			_methodTable = new Array();
	
			// now do everything else
			if (__methodTable__.length > 0) {
				var m:Object;
				while((m = __methodTable__.shift()) != undefined) {
					if (typeof(m.fn) == "string") {
						m.obj[m.fn].apply(m.obj,m.args);
						
					} else {
						m.fn.apply(m.obj,m.args);
					}
				}
			}
			
			if (waitingStack.length == 0) {
				stage.removeEventListener(Event.ENTER_FRAME,doLaterDispatcher);
			}
		}
		
		
		public function callLaterByFrames(frames:Number,callbackThisObj:Object,fn:*,args:Array = null):void {
			waitingStack.push({frames:frames,obj:callbackThisObj, fn:fn,args:args});
			setFrameTimer();
		}
		
	}
	
}