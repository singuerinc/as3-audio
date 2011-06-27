package net.singuerinc.media.audio.manager {

	import org.osflash.signals.Signal;

	/**
	 * @author nahuel.scotti / blog.singuerinc.net
	 */
	public class AudioManagerSignal extends Signal implements IAudioManagerSignal {

		public function AudioManagerSignal() {
			super(AudioManager);
		}
	}
}
