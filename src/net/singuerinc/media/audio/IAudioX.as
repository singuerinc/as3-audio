package net.singuerinc.media.audio {
	/**
	 * @author nahuel.scotti / blog.singuerinc.net
	 */
	public interface IAudioX extends IAudio {

		function set pan(value:Number):void;

		function get pan():Number;

		function set delay(value:uint):void;

		function get delay():uint;

		// methods
		function fade(from:Number = 0, to:Number = 1, time:uint = 1000):void;

		// signals
		function get fadeStarted():IAudioSignal;

		function get fadeCompleted():IAudioSignal;

		function get positionChanged():IAudioSignal;
	}
}
