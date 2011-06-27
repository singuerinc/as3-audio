package net.singuerinc.media.audio.manager {

	import net.singuerinc.media.audio.IAudio;

	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * @author nahuel.scotti
	 */
	public class AudioManager implements IAudioManager {

		protected var _volumeChanged:IAudioManagerSignal;
		protected var _volume:Number;
		protected var _audios:Array;
		protected var _id:String;

		public function AudioManager(id:String) {
			_id = id;
			audios = [];
			_volume = 1;
		}

		public function get id():String {
			return _id;
		}

		public function set audios(value:Array):void {
			_audios = value;
		}

		public function get audios():Array {
			return _audios;
		}

		public function set volume(value:Number):void {
			SoundMixer.soundTransform = new SoundTransform(value);
			_volume = SoundMixer.soundTransform.volume;
			volumeChanged.dispatch(this);
		}

		public function get volume():Number {
			return SoundMixer.soundTransform.volume;
		}

		public function add(audio:IAudio):IAudio {
			if (!_hasWithId(audio.id)) {
				_audios.push(audio);
				return audio;
			} else {
				// TODO: Es demasiado un error, o bastaría con no agregarlo?
				throw new Error('This Audio is already added to AudioManager.');
			}
			return null;
		}

		public function getWithId(id:String):IAudio {
			return _hasWithId(id);
		}

		public function remove(audio:IAudio):IAudio {
			var idx:int = audios.indexOf(audio);
			return audios.splice(idx, 1)[0];
		}

		public function hasWithId(audioId:String):Boolean {
			return _hasWithId(audioId) != null;
		}

		public function removeWithId(audioId:String):IAudio {
			var audio:IAudio = getWithId(audioId);
			if (audio != null) remove(audio);
			return audio;
		}

		private function _hasWithId(audioId:String):IAudio {

			var l:uint = audios.length;
			for (var i:uint = 0; i < l; i++) {
				var audio:IAudio = audios[i];
				if (audio.id == audioId) return audio;
			}
			return null;
		}

		public function parseConfig(value:XML):void {
			var factory:AudioFactory = new AudioFactory();
			for each (var audioNode:XML in value.audio) {
				var audio:IAudio = factory.create(audioNode);
				add(audio);
			}
		}

		public function destroy():void {
			audios = null;
			volumeChanged.removeAll();
		}

		public function get volumeChanged():IAudioManagerSignal {
			return _volumeChanged ||= new AudioManagerSignal();
		}

		public function play(audioId:String):void {
			var audio:IAudio = _hasWithId(audioId);
			audio.play();
		}

		public function pause(audioId:String):void {
			var audio:IAudio = _hasWithId(audioId);
			audio.pause();
		}

		public function resume(audioId:String):void {
			var audio:IAudio = _hasWithId(audioId);
			audio.resume();
		}

		public function stop(audioId:String):void {
			var audio:IAudio = _hasWithId(audioId);
			audio.stop();
		}

		public function playAll():void {
			var l:uint = audios.length;
			for (var i:uint = 0; i < l; i++) {
				var audio:IAudio = audios[i];
				audio.play();
			}
		}

		public function resumeAll():void {
			var l:uint = audios.length;
			for (var i:uint = 0; i < l; i++) {
				var audio:IAudio = audios[i];
				audio.resume();
			}
		}

		public function pauseAll():void {
			var l:uint = audios.length;
			for (var i:uint = 0; i < l; i++) {
				var audio:IAudio = audios[i];
				audio.pause();
			}
		}

		public function stopAll():void {
			var l:uint = audios.length;
			for (var i:uint = 0; i < l; i++) {
				var audio:IAudio = audios[i];
				audio.stop();
			}
		}
	}
}