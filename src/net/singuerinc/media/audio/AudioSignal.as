package net.singuerinc.media.audio {

	import org.osflash.signals.Signal;

	/**
	 * @author nahuel.scotti
	 */
	public class AudioSignal extends Signal implements IAudioSignal {

		public var audio:Audio;

		public function AudioSignal() {
			super(Audio);
		}
		
		override public function dispatch(...args):void {
			audio = args[0] as Audio;
			super.dispatch.apply(this, args);
		}
	}
}
