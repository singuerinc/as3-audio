package net.singuerinc.media.audio {

	import net.singuerinc.media.audio.manager.AudioManager;
	import net.singuerinc.media.audio.manager.IAudioManager;
	import org.flexunit.Assert;
	import flash.media.Sound;

	/**
	 * @author nahuel.scotti
	 */
	public class AudioManagerTest {

		public var manager:IAudioManager;

		[Before]
		public function tearUp():void {
			// audio = new Audio("audioId", mp3);
			manager = new AudioManager('manager');
		}

		[Test]
		public function check_audio_manager_init_values_after_constructor():void {
			Assert.assertEquals('manager', manager.id);
			Assert.assertEquals(1, manager.volume);
		}

		[Test]
		public function check_manager_after_add_some_audios():void {

			const l:uint = 100;
			for (var i:uint = 0; i < l; i++) {
				manager.add(new Audio('' + i, new Sound()));
			}
			Assert.assertEquals(l, manager.audios.length);
		}

		[Test]
		public function check_if_manager_has_audios():void {

			const l:uint = 100;
			for (var i:uint = 0; i < l; i++) {
				manager.add(new Audio('' + i, new Sound()));
				Assert.assertTrue(manager.hasWithId('' + i));
			}
		}

		[Test]
		public function check_if_manager_return_audios():void {

			const l:uint = 100;
			for (var i:uint = 0; i < l; i++) {
				manager.add(new Audio('' + i, new Sound()));
				Assert.assertTrue(manager.getWithId('' + i) is IAudio);
			}
		}

		[Test]
		public function check_if_manager_remove_correctly():void {

			var l:uint = 100;

			for (var i:uint = 0; i < l; i++) {
				manager.add(new Audio('' + i, new Sound()));
				Assert.assertTrue(manager.getWithId('' + i) is IAudio);
			}

			l = 50;

			for (var j:uint = 0; j < l; j++) {
				manager.removeWithId('' + j);
			}

			Assert.assertEquals(50, manager.audios.length);
		}

		[Test]
		public function check_if_manager_remove_one_audio_correctly():void {

			var audio:IAudio = new Audio('audio', new Sound());
			manager.add(audio);
			Assert.assertEquals(1, manager.audios.length);
			var removedAudio:IAudio = manager.remove(audio);
			Assert.assertEquals(0, manager.audios.length);
			Assert.assertEquals(audio, removedAudio);
			Assert.assertEquals('audio', removedAudio.id);
		}

		[After]
		public function tearDown():void {
			manager.destroy();
			manager = null;
		}
	}
}