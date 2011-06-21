package net.singuerinc.media.audio {

	import org.flexunit.Assert;

	/**
	 * @author nahuel.scotti
	 */
	public class AudioTest {

		public var audio:IAudio;

		[Before]
		public function tearUp():void {
			// audio = new Audio("audioId", mp3);
			audio = new Audio("audioId", 'audio.mp3');
		}

		[Test]
		public function check_audio_init_values_after_constructor():void {

			Assert.assertEquals("audioId", audio.id);
			Assert.assertEquals(1, audio.volume);
			Assert.assertNotNull(audio.sound);
			Assert.assertTrue(audio.config is XML);
			Assert.assertFalse(audio.isPlaying());
			Assert.assertEquals(0, audio.loops);
			Assert.assertEquals(0, audio.position);
			Assert.assertEquals(AudioState.STOPPED.state, audio.state.state);
			Assert.assertNotNull(audio.channel);
			Assert.assertNotNull(audio.soundTransform);
		}

		[Test]
		public function set_volume_and_check_if_change():void {
			audio.volume = .5;
			Assert.assertEquals(.5, audio.volume);
		}

		[Test]
		public function set_config_and_check_if_all_props_are_as_expected():void {

			var config:XML = <audio id="newSound" volume=".3" loops="5" position="122" />;
			audio.parseConfig(config);

			Assert.assertTrue(audio.config is XML);

			// el id sólo se puede definir en el constructor
			Assert.assertEquals("audioId", audio.id);
			Assert.assertEquals(.3, audio.volume);
			Assert.assertEquals(5, audio.loops);
			// La posición sólo cambia cuando se realiza un play() | resume()
			Assert.assertEquals(0, audio.position);
			audio.resume();
			// La posición que devuelve el player no es exacta, por lo tanto hemos de hacer un round()
			// FIXME: Sería correcto hacer el round en el get position de Audio?
			Assert.assertEquals(122, Math.round(audio.position));
		}

		[Test]
		public function audio_state_is_PLAYING_after_play_call():void {
			audio.play();
			Assert.assertEquals(AudioState.PLAYING, audio.state);
		}

		[Test]
		public function audio_state_is_PLAYING_after_resume_call():void {
			audio.play();
			audio.pause();
			audio.resume();
			Assert.assertEquals(AudioState.PLAYING.state, audio.state.state);
		}

		[Test]
		public function audio_state_is_PAUSED_after_pause_call():void {
			audio.play();
			audio.pause();
			Assert.assertEquals(AudioState.PAUSED.state, audio.state.state);
		}

		[Test]
		public function audio_state_is_STOPPED_after_stop_call():void {
			audio.play();
			audio.stop();
			Assert.assertEquals(AudioState.STOPPED.state, audio.state.state);
		}

		[After]
		public function tearDown():void {
			audio.stop();
			audio = null;
		}
	}
}