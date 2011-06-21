package net.singuerinc.media.audio {

	import flash.utils.Dictionary;

	/**
	 * @author nahuel.scotti
	 */
	public class AudioManager {

		private var _audios:Dictionary = new Dictionary();
		private var _volume:Number;

		public function parseConfig(xml:XML):void {
		}

		public function add(audio:Audio):void {
			_audios[audio.id] = audio;
		}

		public function getAudio(id:String):Audio {
			return _audios[id];
		}

		public function remove(audio:Audio):void {
			delete _audios[audio.id];
		}

		public function set volume(value:Number):void {
			_volume = value;
		}

		public function get volume():Number {
			return _volume ||= 1.0;
		}
	}
}