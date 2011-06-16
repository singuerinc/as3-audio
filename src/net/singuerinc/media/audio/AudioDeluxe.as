package net.singuerinc.media.audio {


	import flash.media.SoundTransform;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	/**
	 * @author nahuel.scotti
	 */
	public class AudioDeluxe extends Audio {

		public function AudioDeluxe(id:String, sound:*) {
			super(id, sound);
		}

		override public function set volume(value:Number):void {
			var vol:Number = Math.max(0, value);
			// TODO: Es posible optimizar esto?, sin tener que estar creando un nuevo soundTransform?
			// channel.soundTransform.volume = vol;
			channel.soundTransform = new SoundTransform(vol, pan);
			volumeChanged.dispatch(this);
		}

		public function set pan(value:Number):void {
			// TODO: Es posible optimizar esto?, sin tener que estar creando un nuevo soundTransform?
			// channel.soundTransform.pan = value;
			channel.soundTransform = new SoundTransform(volume, value);
		}

		public function get pan():Number {
			return _channel.soundTransform.pan;
		}

		private var _delayedPlay:uint;

		override public function pause():void {
			clearTimeout(_delayedPlay);
			super.pause();
		}

		override public function play():void {

			if (delay) {
				_delayedPlay = setTimeout(super.play, delay);
				return;
			}

			super.play();
		}

		public function fade(from:Number = 0, to:Number = 1, time:uint = 1000):void {
			volume = from;
			_fadeTime = time;
			_fadeFromVolume = from;
			_fadeToVolume = to;
			_fadeCurrentVolume = from;

			clearInterval(_fadeInterval);
			_fadeInterval = setInterval(updateFadeVolume, 100);
		}

		private var _fadeInterval:uint;
		private var _fadeToVolume:Number;
		private var _fadeCurrentVolume:Number;
		private var _fadeTime:uint;
		private var _fadeFromVolume:Number;

		private function updateFadeVolume():void {

			if (!isPlaying()) return;

			if (_fadeCurrentVolume < _fadeToVolume) {
				_fadeCurrentVolume += ((_fadeToVolume - _fadeFromVolume) / (_fadeTime / 100));
				volume = _fadeCurrentVolume;
			} else {
				volume = _fadeCurrentVolume;
				clearInterval(_fadeInterval);
			}
		}

		protected var _delay:uint;

		public function set delay(value:uint):void {
			_delay = value;
		}

		public function get delay():uint {
			return _delay;
		}

		override protected function _parseConfig(audioConfig:XML):XML {

			var c:XML = super._parseConfig(audioConfig);

			// _fadeIn = c.@fadeIn;
			// _fadeOut = c.@fadeOut;
			_delay = c.@delay;

			return c;
		}

	}
}
