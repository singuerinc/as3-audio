package net.singuerinc.media.audio {


	import org.osflash.signals.natives.NativeSignal;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * @author nahuel.scotti / blog.singuerinc.net
	 */
	public class AudioX extends Audio implements IAudioX {

		protected var _defaultEase:Function = function(t:Number, b:Number, c:Number, d:Number):Number {
			return c * t / d + b;
		};

		protected var _s:Sprite = new Sprite();
		protected var _enterFrame:NativeSignal;
		protected var _delayedPlay:uint;

		protected var _positionChanged:IAudioSignal;

		public function AudioX(id:String, sound:*) {
			super(id, sound);
			_enterFrame = new NativeSignal(_s, Event.ENTER_FRAME, Event);
		}

		override public function set volume(value:Number):void {
			var vol:Number = Math.max(0, value);
			_fadeCurrentVolume = value;
			// TODO: Es posible optimizar esto?, sin tener que estar creando un nuevo soundTransform?
			// channel.soundTransform.volume = vol;
			channel.soundTransform = new SoundTransform(vol, pan);
			_volume = channel.soundTransform.volume;

			if (volumeChanged.numListeners > 0)
				volumeChanged.dispatch(this);
		}

		public function set pan(value:Number):void {
			// TODO: Es posible optimizar esto?, sin tener que estar creando un nuevo soundTransform?
			// channel.soundTransform.pan = value;
			channel.soundTransform = new SoundTransform(volume, value);
		}

		public function get pan():Number {
			// FIXME: Hay un bug en flash player, si haces pan(-1), el value no es uno sino -0.9880999999999998
			// por lo tanto no se puede realizar un test
			return _channel.soundTransform.pan;
		}

		override public function pause():void {
			_enterFrame.remove(onChangePosition);
			clearTimeout(_delayedPlay);
			super.pause();
		}

		override public function resume():void {
			super.resume();
			if (isPlaying()) {
				if (positionChanged.numListeners > 0)
					_enterFrame.add(onChangePosition);
			}
		}

		protected function onChangePosition(event:Event):void {
			trace('audio position:', position, 'of:', length);
			positionChanged.dispatch(this);
		}

		public function fade(time:uint = 1000, to:Number = 1, from:Number = -1):void {

			if (!isPlaying()) play();

			_fadeInitValue = (from == -1) ? _volume : from;

			_fadeStartTime = getTimer();
			_fadeElapsed = 0;
			_fadeTotalTime = time;
			_fadeFinalValue = to;

			if (_fadeFinalValue < _fadeInitValue) {
				_fadeFinalValue -= _fadeInitValue;
			}

			_enterFrame.remove(updateFadeVolume);
			_enterFrame.add(updateFadeVolume);

			fadeStarted.dispatch(this);
		}

		public function get fadeStarted():IAudioSignal {
			return _fadeStarted ||= new AudioSignal();
		}

		public function get fadeCompleted():IAudioSignal {
			return _fadeCompleted ||= new AudioSignal();
		}

		protected var _fadeStartTime:int;
		protected var _fadeElapsed:uint;
		protected var _fadeTotalTime:uint;

		protected var _fadeInitValue:Number;
		protected var _fadeFinalValue:Number;

		protected var _fadeCurrentVolume:Number;

		protected var _fadeStarted:IAudioSignal;
		protected var _fadeCompleted:IAudioSignal;

		protected function updateFadeVolume(event:Event):void {

			if (!isPlaying()) return;

			_fadeElapsed = getTimer() - _fadeStartTime;

			if (_fadeElapsed < _fadeTotalTime) {
				var vol:Number = _defaultEase(_fadeElapsed, _fadeInitValue, _fadeFinalValue, _fadeTotalTime);
				volume = vol;
			} else {
				volume = _fadeFinalValue;
				_enterFrame.remove(updateFadeVolume);
				if (fadeCompleted.numListeners > 0) fadeCompleted.dispatch(this);
			}
		}

		public function get positionChanged():IAudioSignal {
			return _positionChanged ||= new AudioSignal();
		}

		override public function destroy():void {

			_enterFrame.removeAll();
			fadeStarted.removeAll();
			fadeCompleted.removeAll();

			super.destroy();

		}

		public function playWithDelay(delay:uint):void {
			if (!isPlaying()) {
				_delayedPlay = setTimeout(super.play, delay);
			}
		}
	}
}