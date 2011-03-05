package emulator
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Emulator {
		private var updateView:Function;
		
		public var delay:int;
		
		private var state:State;
		
		private var runTimer:Timer;
		
		public function Emulator( updateFunction:Function ) {
			this.updateView = updateFunction;
			this.delay = 0;
		}
		
		
		private function canStateExecute( state:State ):Boolean {
			return (!state.isHalted);
		}

		public function step( state:State ):void {
			
			state.processor.pipeline[state.pipelineStep]( state );
			state.pipelineStep = (state.pipelineStep + 1) % state.processor.pipeline.length;
			
			if ( state.pipelineStep == 0 ) {
				// next pipeline step is the start of the cycle
				// a full step has been completed
				state.executionStep++;	
			}
			
			updateView( );
			
			// stop running when halted
			if ( state.isHalted ) {
				stop( );
			}
		}
		
		private function runEvent( event:TimerEvent ):void {
			step( this.state );
		}
		public function run( state:State, maxCycles:int = 0 ):void {
			if ( canStateExecute( state ) ) {
				this.state = state;
				
				var repeatCount:int = (maxCycles * state.processor.pipeline.length);
				if ( runTimer != null ) {
					runTimer.stop( );
					runTimer.delay = delay;
					runTimer.repeatCount = repeatCount;
				} else {
					runTimer = new Timer( delay, repeatCount );
					runTimer.addEventListener( TimerEvent.TIMER, runEvent );
				}
				
				runTimer.start( );
			}
		}
		
		public function stop( ):void {
			if ( runTimer != null ) {
				runTimer.stop( );
			}
		}

	}
}