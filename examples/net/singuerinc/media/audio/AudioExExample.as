package net.singuerinc.media.audio {

	import com.bit101.components.Knob;
	import com.bit101.components.PushButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author nahuel.scotti
	 */

	[SWF(backgroundColor="#242424", frameRate="60", width="640", height="480")]
	public class AudioExExample extends Sprite {

		private var _audio:AudioX;

		public function AudioExExample() {

			new PushButton(this, 20, 20, 'play', onClick);
			new PushButton(this, 20, 45, 'pause', onClick);
			new PushButton(this, 20, 70, 'resume', onClick);
			new PushButton(this, 20, 95, 'stop', onClick);

			var k1:Knob = new Knob(this, 200, 20, 'volume', onVolumeChange);
			k1.minimum = 0;
			k1.maximum = 1;
			k1.value = 1;
			var k2:Knob = new Knob(this, 300, 20, 'pan', onPanChange);
			k2.minimum = -1;
			k2.maximum = 1;
			k2.value = 0;

			// _audio = new AudioDeluxe('id', mp3);
			_audio = new AudioX('id', 'audio.mp3');
			_audio.fadeStarted.add(onAudioFadeStarted);
			_audio.fadeCompleted.add(onAudioFadeCompleted);
			_audio.stateChanged.add(onAudioStateChanged);
			_audio.volumeChanged.add(onAudioVolumeChanged);
			_audio.completed.add(onAudioComplete);
		}

		private function onAudioFadeStarted(audio:Audio):void {
			trace("[Audio] id =", audio.id, '- fade started.');
		}

		private function onAudioFadeCompleted(audio:Audio):void {
			trace("[Audio] id =", audio.id, '- fade completed.');
		}

		private function onAudioComplete(audio:Audio):void {
			trace("[Audio] id =", audio.id, '- completed.');
		}

		private function onAudioVolumeChanged(audio:Audio):void {
			trace("[Audio] id =", audio.id, '- changed volume to:', audio.volume);
		}

		private function onAudioStateChanged(audio:Audio):void {
			trace("[Audio] id =", audio.id, '- changed state to:', audio.state);
		}

		private function onPanChange(event:Event):void {
			var value:Number = (event.currentTarget as Knob).value;
			_audio.pan = value;
			trace("[Audio] id =", _audio.id, '- pab change to:', _audio.pan);
		}

		private function onVolumeChange(event:Event):void {
			var value:Number = (event.currentTarget as Knob).value;
			_audio.volume = value;
		}

		private function onClick(event:MouseEvent):void {
			switch(event.currentTarget.label) {
				case 'play':
					_audio.volume = .5;
					// _audio.delay = 1000;
					_audio.play();
					_audio.fade(3000, 1, 0);
					break;
				case 'pause':
					_audio.pause();
//					_audio.fade(3000, 0, 1);
					break;
				case 'resume':
					_audio.resume();
					break;
				case 'stop':
					_audio.stop();
					break;
			}
		}
	}
}