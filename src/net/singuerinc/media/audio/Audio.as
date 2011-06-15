package net.singuerinc.media.audio {

	import org.osflash.signals.Signal;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	 * @author nahuel.scotti
	 */
	public class Audio {

		private var _id:String;
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		
		private var _fadeIn:Number;
		private var _fadeOut:Number;
		private var _loops:uint;
		private var _volume:Number;
		
		private var _config:XML;
		
		private var _isPlaying:Boolean;
		
		private var _completed:Signal;

		public function Audio(id:String, sound:*) {

			_id = id;

			if (sound is Class) {
				_sound = new sound();
			} else if (sound is Sound) {
				_sound = sound;
			} else if (sound is String) {
				// TODO Load Sound
			} else {
				throw new Error();
			}

			_init();
		}

		private function _init():void {

			_soundChannel = new SoundChannel();
			_config = <sound id={id} volume={volume} loops={loops} fadeIn={fadeIn} fadeOut={fadeOut} position={position} />;

		}

		// signals
		public function get completed():Signal {
			return _completed ||= new Signal(Audio);
		}

		// props
		public function set fadeIn(value:Number):void {
			_fadeIn = Math.max(0, value);
		}

		public function get fadeIn():Number {
			return _fadeIn ||= 0.0;
		}

		public function set fadeOut(value:Number):void {
			_fadeOut = Math.max(0, value);
		}

		public function get fadeOut():Number {
			return _fadeOut ||= 0.0;
		}

		public function get position():Number {
			return soundChannel.position;
		}


		public function get sound():Sound {
			return _sound;
		}


		public function get soundChannel():SoundChannel {
			return _soundChannel;
		}

		public function get length():Number {
			return sound.length;
		}


		public function set loops(value:uint):void {
			_loops = Math.max(0, value);
		}

		public function get loops():uint {
			return _loops ||= 0;
		}


		public function set volume(value:Number):void {
			_volume = Math.max(0, value);
		}

		public function get volume():Number {
			return _volume ||= 1.0;
		}

		public function get id():String {
			return _id;
		}

		public function get isPlaying():Boolean {
			return _isPlaying;
		}
	}
}
