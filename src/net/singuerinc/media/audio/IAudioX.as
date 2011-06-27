package net.singuerinc.media.audio {
	/**
	 * @author nahuel.scotti / blog.singuerinc.net
	 */
	public interface IAudioX extends IAudio {

		function playWithDelay(delay:uint):void;

		function set pan(value:Number):void;

		function get pan():Number;

		// methods
		function fade(time:uint = 1000, to:Number = 1, from:Number = -1):void;

		// signals
		function get fadeStarted():IAudioSignal;

		function get fadeCompleted():IAudioSignal;

		function get positionChanged():IAudioSignal;
	}
}
