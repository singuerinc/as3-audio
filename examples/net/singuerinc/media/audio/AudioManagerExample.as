package net.singuerinc.media.audio {

	import net.singuerinc.media.audio.manager.AudioManager;
	import net.singuerinc.media.audio.manager.IAudioManager;

	import com.bit101.components.Knob;
	import com.bit101.components.PushButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author nahuel.scotti
	 */

	[SWF(backgroundColor="#242424", frameRate="60", width="640", height="480")]
	public class AudioManagerExample extends Sprite {

		private var _audioManager:IAudioManager;

		public function AudioManagerExample() {

			new PushButton(this, 20, 20, 'play', onClick);
			new PushButton(this, 20, 45, 'pause', onClick);
			new PushButton(this, 20, 70, 'resume', onClick);
			new PushButton(this, 20, 95, 'stop', onClick);

			var k1:Knob = new Knob(this, 200, 20, 'volume', onVolumeChange);
			k1.minimum = 0;
			k1.maximum = 1;
			k1.value = 1;

			// _audio = new AudioDeluxe('id', mp3);
			_audioManager = new AudioManager('manager1');
			_audioManager.volumeChanged.add(onAudioVolumeChanged);
		}

		private function onAudioVolumeChanged(audioManager:IAudioManager):void {
			trace("[AudioManager] id =", audioManager.id, '- changed volume to:', audioManager.volume);
		}

		private function onVolumeChange(event:Event):void {
			var value:Number = (event.currentTarget as Knob).value;
			_audioManager.volume = value;
		}

		private function onClick(event:MouseEvent):void {
			switch(event.currentTarget.label) {
				case 'play':
					_audioManager.add(new Audio('audio1', 'audio.mp3'));
					_audioManager.add(new Audio('audio2', 'audio.mp3'));
					_audioManager.play('audio1');
					break;
				case 'pause':
					_audioManager.pause('audio1');
					break;
				case 'resume':
					_audioManager.resume('audio1');
					break;
				case 'stop':
					_audioManager.stop('audio1');
					break;
			}
		}
	}
}