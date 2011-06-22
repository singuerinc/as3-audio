package net.singuerinc.media.audio {

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * @author nahuel.scotti
	 */
	public class Audio implements IAudio {

		protected var _id:String;

		protected var _sound:Sound;
		protected var _channel:SoundChannel;

		protected var _loops:uint;
		protected var _volume:Number;

		protected var _config:XML;

		protected var _state:AudioState;
		protected var _isPlaying:Boolean;
		protected var _pausePosition:Number;

		protected var _completed:IAudioSignal;
		protected var _stateChanged:IAudioSignal;
		protected var _volumeChanged:IAudioSignal;


		public function Audio(id:String, sound:*) {

			if (sound is Class) {
				_sound = new sound();
			} else if (sound is Sound) {
				_sound = sound;
			} else if (sound is String) {
				_sound = new Sound(new URLRequest(sound));
			} else if (sound is URLRequest) {
				_sound = new Sound(sound);
			} else {
				throw new Error('Parameter "sound" must be an instance of Sound, a Class that extends of Sound or an url to mp3/wav.');
			}

			_id = id;
			_channel = new SoundChannel();
			_state = AudioState.STOPPED;

			_volume = 1;
			_loops = 0;
			_pausePosition = 0;
		}


		// basic methods
		public function play():void {
			if (!isPlaying()) {
				_pausePosition = 0;
				resume();
			}
		}

		public function pause():void {
			if (isPlaying()) {
				_pausePosition = position;
				_channel.stop();
				_isPlaying = false;
				_channel.removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
				if (_state != AudioState.STOPPED) {
					_state = AudioState.PAUSED;
					stateChanged.dispatch(this);
				}
			}
		}

		public function resume():void {

			if (!isPlaying()) {
				_channel = sound.play(_pausePosition, loops, soundTransform);
				_channel.addEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
				_isPlaying = true;
				_state = AudioState.PLAYING;
				stateChanged.dispatch(this);
			}
		}

		public function stop():void {

			if (isPlaying()) {
				_state = AudioState.STOPPED;
				pause();
				_pausePosition = 0;
				stateChanged.dispatch(this);
			}
		}

		public function set volume(value:Number):void {
			var vol:Number = Math.max(0, value);
			channel.soundTransform = new SoundTransform(vol);
			_volume = channel.soundTransform.volume;
			volumeChanged.dispatch(this);
		}

		public function get volume():Number {
			return soundTransform.volume;
		}





		// signals

		private function _onSoundComplete(event:Event):void {
			_channel.removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
			stop();
			completed.dispatch(this);
		}

		public function get completed():IAudioSignal {
			return _completed ||= new AudioSignal();
		}

		public function get stateChanged():IAudioSignal {
			return _stateChanged ||= new AudioSignal();
		}

		public function get volumeChanged():IAudioSignal {
			return _volumeChanged ||= new AudioSignal();
		}




		// props
		public function get length():Number {
			return sound.length;
		}

		public function get position():Number {
			return channel.position;
		}

		public function get state():AudioState {
			return _state;
		}

		public function get sound():Sound {
			return _sound;
		}

		public function get channel():SoundChannel {
			return _channel;
		}






		// FIXME: Y que hacemos cuando hace set de un loop despues
		// de darle a play?
		// Los loops deberían ir bajando a medida que se va haciendo play?
		public function set loops(value:uint):void {
			_loops = Math.max(0, value);
		}

		public function get loops():uint {
			return _loops ||= 0;
		}


		public function get id():String {
			return _id;
		}

		public function isPlaying():Boolean {
			return _isPlaying;
		}

		public function get soundTransform():SoundTransform {
			return _channel.soundTransform;
		}



		public function parseConfig(value:XML):void {
			_config = _parseConfig(value);
		}

		public function get config():XML {
			return _config || <audio id={_id} volume={volume} loops={loops} />;
		}

		protected function _parseConfig(audioConfig:XML):XML {

			var c:XML = audioConfig;

			// _id = c.@id;
			volume = c.@volume || volume;
			_loops = c.@loops || loops;
			_pausePosition = c.@position || _pausePosition;

			return c;
		}

		public function destroy():void {
			stop();
			_channel.removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
			completed.removeAll();
			stateChanged.removeAll();
			volumeChanged.removeAll();
		}
	}
}
