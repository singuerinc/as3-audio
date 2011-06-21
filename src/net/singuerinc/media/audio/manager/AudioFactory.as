package net.singuerinc.media.audio.manager {
	import net.singuerinc.media.audio.Audio;
	import net.singuerinc.media.audio.AudioX;
	import net.singuerinc.media.audio.IAudio;
	/**
	 * @author nahuel.scotti / blog.singuerinc.net
	 */
	public class AudioFactory {

		public function create(data:XML):IAudio {

			var audio:IAudio;
			var AudioClass:Class;

			if (data.@delay != undefined || data.@pan != undefined) {
				AudioClass = AudioX;
			} else {
				AudioClass = Audio;
			}

			audio = new AudioClass(data.@id, data.@src);
			audio.parseConfig(data);

			return audio;
		}
	}
}
