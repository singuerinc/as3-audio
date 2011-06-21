package net.singuerinc.media.audio.manager {

	import net.singuerinc.media.audio.IAudio;

	/**
	 * @author nahuel.scotti / blog.singuerinc.net
	 */
	public interface IAudioManager {
		
		function get id():String;
		
		function add(audio:IAudio):uint;

		function hasWithId(audioId:String):Boolean;

		function getWithId(audioId:String):IAudio;

		function remove(audio:IAudio):IAudio;

		function removeWithId(audioId:String):IAudio;

		function set volume(value:Number):void;

		function get volume():Number;

		function set audios(value:Array):void;

		function get audios():Array;

		function parseConfig(value:XML):void;

		function destroy():void;


		// signals
		function get onVolumeChange():IAudioManagerSignal;
	}
}
