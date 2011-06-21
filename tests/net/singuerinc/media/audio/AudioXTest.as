package net.singuerinc.media.audio {

	import org.flexunit.Assert;

	/**
	 * @author nahuel.scotti
	 */
	public class AudioXTest {

		public var audio:IAudioX;

		[Before]
		public function tearUp():void {
			// audio = new Audio("audioId", mp3);
			audio = new AudioX("audioId", 'audio.mp3');
		}

		[Test]
		public function check_audio_init_values_after_constructor():void {

			Assert.assertEquals(0, audio.delay);
			Assert.assertEquals(0, audio.pan);
			Assert.assertTrue(audio.fadeStarted is IAudioSignal);
			Assert.assertTrue(audio.fadeCompleted is IAudioSignal);
			Assert.assertTrue(audio.positionChanged is IAudioSignal);
		}

		[Test]
		public function check_after_fade_call():void {
			Assert.assertEquals(1, audio.volume);
			audio.fade(1000, 1, 0);
			Assert.assertEquals(0, audio.volume);
			Assert.assertTrue(audio.isPlaying());
		}

		[Test]
		public function check_delay_after_set_delay():void {
			Assert.assertEquals(0, audio.delay);
			audio.delay = 1000;
			Assert.assertEquals(1000, audio.delay);
		}
		
		[Test]
		public function check_audio_volumeChanged_signal_when_set_volume():void {
			
			Assert.assertEquals(0, audio.volumeChanged.numListeners);
			audio.volumeChanged.add(_onSignal);
			Assert.assertEquals(1, audio.volumeChanged.numListeners);
			audio.volume = 1;
			audio.volumeChanged.remove(_onSignal);
			Assert.assertEquals(0, audio.volumeChanged.numListeners);
			Assert.assertEquals(1, audio.volume);
		}
		
		[Test]
		public function check_audio_fadeStarted_signal_when_fade():void {
			
			Assert.assertEquals(0, audio.fadeStarted.numListeners);
			audio.fadeStarted.addOnce(_onSignal);
			Assert.assertEquals(1, audio.fadeStarted.numListeners);
			audio.fade(1000, 1, 0);
			Assert.assertEquals(0, audio.fadeStarted.numListeners);
		}
		
		[Test]
		public function check_pan_after_set():void {
			
			Assert.assertEquals(0, audio.pan);
			audio.pan = 1;
			Assert.assertEquals(1, audio.pan);
			audio.pan = 0;
			Assert.assertEquals(0, audio.pan);
			audio.pan = -1;
			//There is a bug in Flash Player when set pan in soundTransform to -1, the return value is wrong
			Assert.assertEquals(-0.9880999999999998, audio.pan);
		}

		private function _onSignal(audio:IAudioX):void {
		}

		[After]
		public function tearDown():void {
			audio.stop();
			audio = null;
		}
	}
}