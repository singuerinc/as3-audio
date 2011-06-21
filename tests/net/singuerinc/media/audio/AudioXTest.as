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

			Assert.assertEquals(audio.delay, 0);
			Assert.assertEquals(audio.pan, 0);
			Assert.assertTrue(audio.fadeStarted is IAudioSignal);
			Assert.assertTrue(audio.fadeCompleted is IAudioSignal);
			Assert.assertTrue(audio.positionChanged is IAudioSignal);
		}

		[Test]
		public function check_after_fade_call():void {
			Assert.assertEquals(audio.volume, 1);
			audio.fade(0, 1, 1000);
			Assert.assertEquals(audio.volume, 0);
			Assert.assertTrue(audio.isPlaying());
		}

		[Test]
		public function check_delay_after_set_delay():void {
			Assert.assertEquals(audio.delay, 0);
			audio.delay = 1000;
			Assert.assertEquals(audio.delay, 1000);
		}
		
		[Test]
		public function check_audio_volumeChanged_signal_when_set_volume():void {
			
			Assert.assertEquals(audio.volumeChanged.numListeners, 0);
			audio.volumeChanged.add(_onSignal);
			Assert.assertEquals(audio.volumeChanged.numListeners, 1);
			audio.volume = 1;
			audio.volumeChanged.remove(_onSignal);
			Assert.assertEquals(audio.volumeChanged.numListeners, 0);
			Assert.assertEquals(audio.volume, 1);
		}
		
		[Test]
		public function check_audio_fadeStarted_signal_when_fade():void {
			
			Assert.assertEquals(audio.fadeStarted.numListeners, 0);
//			Assert.assertEquals(audio.fadeCompleted.numListeners, 0);
//			Assert.assertEquals(audio.positionChanged.numListeners, 0);
			
			audio.fadeStarted.addOnce(_onSignal);
//			audio.fadeCompleted.addOnce(_onFadeCompleted);
//			audio.positionChanged.addOnce(_onPositionChanged);
			
			Assert.assertEquals(audio.fadeStarted.numListeners, 1);
//			Assert.assertEquals(audio.fadeCompleted.numListeners, 1);
//			Assert.assertEquals(audio.positionChanged.numListeners, 1);
			
			audio.fade(0, 1, 1000);
			
			Assert.assertEquals(audio.fadeStarted.numListeners, 0);
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