package net.singuerinc.media.audio.manager {

	import org.osflash.signals.ISignal;

	/**
	 * @author nahuel.scotti / blog.singuerinc.net
	 */
	public interface IAudioManagerSignal extends ISignal {

		// FIXME: dispatch en la versión v8.0 no existe en ISignal, pero supongo que existirá en la v0.9
		function dispatch(...args):void;

		function removeAll():void;
	}
}
