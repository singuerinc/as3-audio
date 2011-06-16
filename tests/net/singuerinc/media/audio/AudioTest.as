package net.singuerinc.media.audio {

	import org.flexunit.Assert;

	/**
	 * @author nahuel.scotti
	 */
	public class AudioTest {

		[Embed(source='../../../../../bin/audio.mp3')]
		public var mp3:Class;

		public var audio:Audio;

		[Before]
		public function tearUp():void {
			audio = new Audio("audioId", mp3);
//			audio = new Audio("audioId", 'audio.mp3');
		}

		[Test]
		public function check_audio_init_values_after_constructor():void {

			Assert.assertEquals(audio.id, "audioId");
			Assert.assertEquals(audio.volume, 1);
			Assert.assertNotNull(audio.sound);
			Assert.assertTrue(audio.config is XML);
			Assert.assertFalse(audio.isPlaying());
			Assert.assertEquals(audio.loops, 0);
			Assert.assertEquals(audio.position, 0);
			Assert.assertEquals(audio.state, -1);
			Assert.assertNotNull(audio.channel);
			Assert.assertNotNull(audio.soundTransform);
		}

		[Test]
		public function set_volume_and_check_if_change():void {
			audio.volume = .5;
			Assert.assertEquals(audio.volume, .5);
		}

		[Test]
		public function set_config_and_check_if_all_props_are_as_expected():void {

			var newConfig:XML = <sound id="newSound" volume=".3" loops="5" fadeIn=".5" fadeOut="2" position="122" />;
			audio.config = newConfig;

			Assert.assertTrue(audio.config is XML);

			// el id sólo se puede definir en el constructor
			Assert.assertEquals(audio.id, "audioId");
			Assert.assertEquals(audio.volume, .3);
			Assert.assertEquals(audio.loops, 5);
			// la posición sólo cambia cuando se realiza un play() | resume()
			Assert.assertEquals(audio.position, 0);
		}

		[Test]
		public function audio_state_is_PLAYING_after_play_call():void {
			audio.play();
			Assert.assertEquals(audio.state, Audio.PLAYING);
		}

		[Test]
		public function audio_state_is_PLAYING_after_resume_call():void {
			audio.play();
			audio.pause();
			audio.resume();
			Assert.assertEquals(audio.state, Audio.PLAYING);
		}

		[Test]
		public function audio_state_is_PAUSED_after_pause_call():void {
			audio.play();
			audio.pause();
			Assert.assertEquals(audio.state, Audio.PAUSED);
		}

		[Test]
		public function audio_state_is_STOPPED_after_stop_call():void {
			audio.play();
			audio.stop();
			Assert.assertEquals(audio.state, Audio.STOPPED);
		}

		[After]
		public function tearDown():void {
			audio = null;
		}
	}
}