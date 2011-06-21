package net.singuerinc.media.audio {

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author nahuel.scotti / blog.singuerinc.net
	 */
	public interface IAudio {

		function play():void;

		function pause():void;

		function resume():void;

		function stop():void;

		function set volume(value:Number):void;

		function get volume():Number;

		function get completed():AudioSignal;

		function get stateChanged():AudioSignal;

		function get volumeChanged():AudioSignal;

		function get length():Number;

		function get position():Number;

		function get state():AudioState;

		function get sound():Sound;

		function get channel():SoundChannel;

		function set loops(value:uint):void;

		function get loops():uint;

		function get id():String;

		function isPlaying():Boolean;

		function get soundTransform():SoundTransform;

		function set config(audioConfig:XML):void;

		function get config():XML;
	}
}
