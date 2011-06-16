package net.singuerinc.media.audio {

	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import flash.display.MovieClip;

	[SWF(width='1000', height='800', backgroundColor='#333333', frameRate='31')]
	public class AllTestsRunner extends MovieClip {

		private var core:FlexUnitCore;

		public function AllTestsRunner():void {

			core = new FlexUnitCore();
			core.addListener(new TraceListener());
			core.run(AllTests);
		}

	}
}

