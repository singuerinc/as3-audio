package net.singuerinc.media.audio {
	/**
	 * @author nahuel.scotti / blog.singuerinc.net
	 */
	public class AudioState {

		public static const PLAYING:AudioState = new AudioState(0x01);
		public static const STOPPED:AudioState = new AudioState(0x02);
		public static const PAUSED:AudioState = new AudioState(0x03);

		private var _state:int;

		public function AudioState(state:int) {
			_state = state;
		}

		public static function stateToString(state:int):String {
			switch(state) {
				case PLAYING.state:
					return "playing";
				case STOPPED.state:
					return "stopped";
				case PAUSED.state:
					return "paused";
				default:
					throw new ArgumentError("Unknown state");
			}
		}

		public function get state():int {
			return _state;
		}
	}
}
