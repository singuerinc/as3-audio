package net.singuerinc.media.audio.manager {

	import net.singuerinc.media.audio.IAudio;
	import flash.media.SoundMixer;

	/**
	 * @author nahuel.scotti
	 */
	public class AudioManager implements IAudioManager {

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

		// props
		public function set volume(value:Number):void {
			_volume = SoundMixer.soundTransform.volume = value;
			onVolumeChange.dispatch(_volume);
		}

		public function get volume():Number {
			return _volume ||= 1.0;
		}

		// methods
		public function add(audio:IAudio):uint {
			if (_hasWithId(audio.id) == null) {
				return _audios.push(audio);
			} else {
				// TODO: Es demasiado un error, o bastaría con no agregarlo?
				throw new Error('This Audio is already added to AudioManager.');
			}
			return _audios.length;
		}

		public function getWithId(id:String):IAudio {
			return _hasWithId(id);
		}

		public function remove(audio:IAudio):IAudio {

//			if (audio != null) {
				var idx:int = audios.indexOf(audio);
				return audios.splice(idx, 1)[0];
//			}
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
		}

		private var _onVolumeChange:IAudioManagerSignal;

		public function get onVolumeChange():IAudioManagerSignal {
			return _onVolumeChange ||= new AudioManagerSignal();
		}
	}
}