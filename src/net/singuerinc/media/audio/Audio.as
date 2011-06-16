package net.singuerinc.media.audio {

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * @author nahuel.scotti
	 */
	public class Audio {

		public static const STOPPED:int = -1;
		public static const PAUSED:int = 0;
		public static const PLAYING:int = 1;

		protected var _id:String;

		protected var _sound:Sound;
		protected var _channel:SoundChannel;

		protected var _loops:uint;
		protected var _volume:Number;

		protected var _config:XML;

		protected var _state:int;
		protected var _isPlaying:Boolean;
		protected var _pausePosition:Number;

		protected var _completed:AudioSignal;
		protected var _stateChanged:AudioSignal;
		protected var _volumeChanged:AudioSignal;


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
				throw new Error('Parameter "sound" must be an instance of Sound or a Class that extends of Sound.');
			}

			_id = id;
			_channel = new SoundChannel();
			_state = STOPPED;

			config = <sound id={_id} volume="1" loops="0" fadeIn="0" fadeOut="0" position="0" delay="0" />;
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
				if (_state != STOPPED) {
					_state = PAUSED;
					stateChanged.dispatch(this);
				}
			}
		}

		public function resume():void {

			if (!isPlaying()) {
				_channel = sound.play(_pausePosition, loops, soundTransform);
				_channel.addEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
				_isPlaying = true;
				_state = PLAYING;
				stateChanged.dispatch(this);
			}
		}

		public function stop():void {

			if (isPlaying()) {
				_state = STOPPED;
				pause();
				_pausePosition = 0;
				stateChanged.dispatch(this);
			}
		}

		public function set volume(value:Number):void {
			var vol:Number = Math.max(0, value);
			channel.soundTransform = new SoundTransform(vol);
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

		public function get completed():AudioSignal {
			return _completed ||= new AudioSignal();
		}

		public function get stateChanged():AudioSignal {
			return _stateChanged ||= new AudioSignal();
		}

		public function get volumeChanged():AudioSignal {
			return _volumeChanged ||= new AudioSignal();
		}




		// props
		public function get length():Number {
			return sound.length;
		}

		public function get position():Number {
			return channel.position;
		}

		public function get state():int {
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





		public function set config(audioConfig:XML):void {
			_config = _parseConfig(audioConfig);
		}

		public function get config():XML {
			return _config;
		}

		protected function _parseConfig(audioConfig:XML):XML {

			var c:XML = audioConfig;

			// _id = c.@id;
			volume = c.@volume;
			loops = c.@loops;
			_pausePosition = c.@position;

			return c;
		}



	}
}
