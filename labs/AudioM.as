package net.singuerinc.labs.media {

	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VolumePlugin;
	import org.osflash.signals.Signal;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;

	/**
	 * <p>La classe Audio posee m&eacute;todos est&aacute;ticos para controlar el sonido de una aplicaci&oacute;n.<br/>
	 * Tambi&eacute;n se puede utilizar en forma de objeto y controlar de forma avanzada cada uno de los sonidos.</p>
	 *
	 * @example
	 *
	 * <listing version="3.0">
	 *
	 * // versi&oacute;n con est&aacute;tica
	 * Audio.playSnd(new SoundClass(), {volume: .5});
	 *
	 * // Tambi&eacute;n se puede crear un objeto y tener m&aacute;s control
	 * // sobre la reproducci&oacute;n de un sonido.
	 *
	 * var snd:Audio = new Audio(new SoundClass());
	 * snd.play({volume: .3, fadeTime: 1});
	 * snd.pause({delay: 1.5, volume: 0});
	 * snd.resume({delay: 4, volume: 1});
	 * snd.stop({delay: 7, fadeTime: 2});
	 *
	 * @author nahuel scotti
	 */
	public class AudioM {

		public var id:String;
		public var sound:Sound;
		public var soundChannel:SoundChannel;

		private var _configuration:XML;

		// private var _vars:Object;
		private var _playing:Boolean;
		private var _paused:Boolean;
		private var _pausePosition:Number;
		private static const __DEFAULT_SOUND_CONFIG:XML = <sound id="" volume="1" loops="1" fadeInTime="0" fadeOutTime="0" position="0" />;

		public static var changed:Signal;

		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		public static const RESUME:String = "resume";
		public static const STOP:String = "stop";

		/**
		 * <p>Contructor</p>
		 *
		 * @param sound Un objeto de tipo <code>Sound</code>.
		 * @param vars Un objeto que define la caracter&iacute;sticas del sonido y la reproducci&oacute;n.
		 *
		 * @example
		 * <listing version="3.0">
		 * var snd:Audio = new Audio(new SoundClassExample(), "snd");
		 * snd.play({fadeTime: 2, volume: .5});
		 * </listing>
		 */
		public function AudioM(sound:Sound, id:String = "") {

			// Init global Audio manager
			if (!__init) init();

			_playing = false;

			_configuration = __getSoundConfig(id);

			this.id = _configuration.@id;
			this.sound = sound;
			this.soundChannel = new SoundChannel();

			var volume:Number = _configuration.@volume;
			setVolume(volume);

			__allAudio.push(this);
		}

		private function __getSoundConfig(id:String):XML {
			var node:XML = __config.sound.sound.(@id == id)[0];
			return node || __DEFAULT_SOUND_CONFIG;
		}

		/**
		 * @copy SoundChannel#position
		 */
		public function get position():Number {
			return soundChannel.position;
		}

		/**
		 * @copy Sound#length
		 */
		public function get length():Number {
			return sound.length;
		}

		/**
		 * <p>Si es <i>true</i> indica que el sonido se est&aacute; reproduciendo.</p>
		 *
		 * @example
		 * <listing version="3.0">
		 * snd.play();
		 * trace(snd.playing); // true
		 * // ...
		 * snd.play({delay: 2});
		 * trace(snd.playing); // false</listing>
		 */
		public function get playing():Boolean {
			return _playing;
		}


		private var __volume:Number;

		/**
		 * <p>Ajusta el volumen del sonido que se est&aacute; reproduciendo.</p>
		 *
		 * @see #getVolume()
		 *
		 * @param volume Un valor de 0 a 1
		 * @param vars Un objeto que contiene propiedades que se aplican al sonido, como "fadeTime"
		 *
		 * @example
		 * <listing version="3.0" >
		 * var snd:Audio = new Audio(new SoundClass());
		 * snd.setVolume(.5, {fadeTime: 2.5});
		 * </listing>
		 */
		public function setVolume(volume:Number, fadeTime:Number = 0, delay:Number = 0):void {
			volume = Math.max(0, volume);
			setTimeout(__setVolume, delay * 1000 || 0, Math.min(1, volume), fadeTime);
		}

		/**
		 * <p>Devuelve el volumen actual del sonido.</p>
		 *
		 * @see #setVolume()
		 *
		 * @return Un n&uacute;mero que va entre 0 y 1
		 *
		 * @example
		 * <listing version="3.0" >
		 * var snd:Audio = new Audio(new SoundClass(), {volume: .5});
		 * snd.getVolume(); // .5</listing>
		 */
		public function getVolume():Number {
			return soundChannel.soundTransform.volume;
		}

		/**
		 * @private
		 * <p>Ajusta el volumen de un sonido.</p>
		 *
		 * @param volume Un valor entre 0 y 1
		 * @param fadeTime
		 */
		private function __setVolume(volume:Number, fadeTime:Number):void {
			__volume = getVolume();
			TweenLite.to(soundChannel, fadeTime || 0, {volume:volume});
		}



		// // // // // // // // // // // ////////////////////
		// PLAY, STOP, PAUSE, RESUME, etc
		// // // // // // // // // // // ////////////////////


		/**
		 * <p>Reproduce un sonido.</p>
		 *
		 * @see #resume()
		 * @see #pause()
		 * @see #stop()
		 *
		 * @param vars Un objeto donde se pueden definir propiedades que afectar&aacute;n
		 * a la reproducci&oacute;n del mismo: "volume", "fadeTime", "position", "loops", "delay".
		 *
		 * @return Un objeto de tipo <code>Audio</code>
		 *
		 * @example
		 * <listing version="3.0" >
		 * var snd:Audio = Audio.play("snd");
		 * // ...
		 * snd.play({volume: .5, fadeTime: 1.5, delay: 2, loops: 2, position: 3400});</listing>
		 */
		public function play(vars:Object = null):AudioM {
			if (vars == null) vars = {};
			setTimeout(__play, vars.delay * 1000 || 0, vars);
			return this;
		}

		/**
		 * @private
		 * <p>Reproduce un sonido.</p>
		 * @param vars
		 */
		private function __play(vars:Object):void {

			if (playing) return;

			var wasPaused:Boolean = _paused;

			for (var i:String in vars) {
				vars[i];
			}

			if (vars.id != undefined) {
				id = vars.id;
			}

			var loops:uint = vars.loops || 0;

			var vol:Number = vars.volume || getVolume();

			if (_paused) {
				vars.position = (vars.position != undefined) ? vars.position : _pausePosition;
			}

			var prevPosition:Number = vars.position || 0;

			soundChannel = sound.play(prevPosition, loops);
			soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);

			var initVolume:Number = (vars.fadeTime != undefined) ? 0 : 1;

			soundChannel.soundTransform = new SoundTransform(initVolume);

			_playing = true;
			_paused = false;

			setVolume(vol, vars.fadeTime || 0);

			if (vars.onChangeState != undefined) {
				stateChanged.add(vars.onChangeState);
			}

			if (vars.onComplete != undefined) {
				completed.add(vars.onComplete);
			}

			if (wasPaused) {
				stateChanged.dispatch(this, RESUME);
			} else {
				stateChanged.dispatch(this, PLAY);
			}

		}

		private function onSoundComplete(event:Event):void {
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			stateChanged.dispatch(this, STOP);
			completed.dispatch(this);
			stateChanged.removeAll();
			completed.removeAll();
		}

		private var _stateChanged:Signal;

		public function get stateChanged():Signal {
			return _stateChanged ||= new Signal(AudioM, String);
		}

		private var _completed:Signal;

		public function get completed():Signal {
			return _completed ||= new Signal(AudioM);
		}

		/**
		 * <p>Detiene la reproducci&oacute;n de un sonido.</p>
		 *
		 * @see #resume()
		 * @see #pause()
		 * @see #play()
		 *
		 * @param vars Un objeto con propiedades que afectan el stop del sonido.
		 *
		 * @return Un objeto <code>Audio</code>
		 *
		 * @example
		 * <listing version="3.0" >
		 * var snd:Audio = new Audio(new SoundClass());
		 * snd.play();
		 * // ...
		 * snd.stop({fadeTime: 1.5, delay: 2});</listing>
		 */
		public function stop(vars:Object = null):AudioM {
			if (vars == null) vars = {};
			setTimeout(__stop, vars.delay * 1000 || 0, vars);
			return this;
		}

		/**
		 * @private
		 * @param vars
		 */
		private function __stop(vars:Object):void {
			if (!this.soundChannel) return;
			if (!playing) return;
			TweenLite.to(this.soundChannel, vars.fadeTime || 0, {volume:vars.volume || 0, onComplete:this.__stopNow, onCompleteParams:[vars]});
		}

		/**
		 * @private
		 * @param vars
		 */
		private function __stopNow(vars:Object):void {

			_playing = false;
			_paused = vars.pause || false;

			_pausePosition = (_paused == true) ? soundChannel.position : 0;
			this.soundChannel.stop();

			if (_paused) {
				stateChanged.dispatch(this, PAUSE);
			} else {
				stateChanged.dispatch(this, STOP);
			}
		}

		/**
		 * <p>Detiene la reproducci&oacute;n de un sonido.</p>
		 *
		 * @see #resume()
		 * @see #play()
		 * @see #stop()
		 *
		 * @param vars Un objeto que afecta la detenci&oacute;n del sonido.
		 *
		 * @return Un objeto <code>Audio</code>
		 *
		 * @example
		 * <listing version="3.0" >
		 * var snd:Audio = Audio.play("snd");
		 * ...
		 * snd.pause({delay: 2.3, fadeTime: 1.5});</listing>
		 */
		public function pause(vars:Object = null):AudioM {
			if (vars == null) vars = {};
			vars.pause = true;
			var sndMax:AudioM = stop(vars);
			return sndMax;
		}

		/**
		 * <p>Reanuda la reproducci&oacute;n de un sonido.</p>
		 *
		 * @see #play()
		 * @see #pause()
		 * @see #stop()
		 *
		 * @param vars Un objeto que afecta un sonido previamente detenido.
		 *
		 * @return Un objeto <code>Audio</code>
		 *
		 * @example
		 * <listing version="3.0" >
		 * var snd:Audio = Audio.play("snd");
		 * // ...
		 * snd.resume({delay: 1.3, fadeTime: .5, volume: .45});</listing>
		 */
		public function resume(vars:Object = null):AudioM {
			if (vars == null) vars = {};
			return play(vars);
		}





		// // // // // // // // ///////////////////////////////
		//
		// STATICs
		//
		// // // // // // // // ///////////////////////////////

		// Contiene una lista de todos los objetos Audio
		// FIXME: Y que pasa con el Garabage collection¿?¿
		private static var __allAudio:Array;
		// Indica si ya se ha iniciado Audio
		private static var __init:Boolean;
		// Indica si el sonido global est&aacute; activado o desactivado
		private static var __enabled:Boolean;
		private static var __config:XML;

		public static function init():void {

			TweenPlugin.activate([VolumePlugin]);

			__config = <sound volume="1" />;
			__init = true;
			__enabled = true;
			__allAudio = [];
			__internal_volume = 1;

			changed = new Signal(Boolean);
		}

		/**
		 * <p>Activa o desactiva el sonido global.</p>
		 *
		 * @param value Un valor booleano <code>true|false</code>
		 * @param vars Un objeto que afecta las propiedades del sonido global.
		 *
		 * @example
		 * <listing version="3.0" >Audio.enabled(true, {fadeTime: 1, delay: 2, volume: .5 });</listing>
		 */
		public static function enabled(value:Boolean, vars:Object = null):void {

			if (value == __enabled) return;

			if (vars == null) {
				vars = {};
			}
			__enabled = value;
			if (__enabled) {
				setGlobalVolume(vars.volume || __internal_volume, vars);
			} else {
				__internal_volume = SoundMixer.soundTransform.volume;
				setGlobalVolume(0, vars);
			}

			changed.dispatch(__enabled);
		}

		/**
		 * <p>Si su valor es <em>true</em> entonces el sonido global esta activado.</p>
		 *
		 * @example
		 * <listing version="3.0" >
		 * Audio.enabled(true);
		 * trace(Audio.isEnabled); // true
		 * // ...
		 * Audio.enabled(true, {fadeTime: 1, delay: 2, volume: .5 });
		 * trace(Audio.isEnabled); // true
		 * // ...
		 * Audio.enabled(false);
		 * trace(Audio.isEnabled); // false</listing>
		 */
		public static function get isEnabled():Boolean {
			return __enabled;
		}

		/**
		 * <p>Devuelve el nivel de sonido global.</p>
		 *
		 * @see Audio#setGlobalVolume()
		 *
		 * @return Un valor de tipo Number que va de 0 a 1.
		 *
		 * @example
		 * <listing version="3.0" >
		 * Audio.setGlobalVolume(.75);
		 * Audio.getGlobalVolume(); // 0.75</listing>
		 */
		public static function getGlobalVolume():Number {
			return SoundMixer.soundTransform.volume;
		}

		/**
		 * <p>Ajusta el sonido global, el volumen de todos los sonidos
		 * se ver&aacute; afectado. Hay que tener en cuenta que si
		 * definimos un valor de "globalVolume" en .5 el sonido que
		 * tenga volume 1 se ajustar&aacute; en .5 y el que tenga como
		 * volume .2 se ajustar&aacute; en .1</p>
		 *
		 * @see Audio#getGlobalVolume()
		 *
		 * @param volume Un valor que va de 0 a 1.
		 * @param vars Un objeto que define propiedades del sonido global.
		 *
		 * @example
		 * <listing version="3.0" >Audio.setGlobalVolume(.5, {fadeTime: .5, delay: .5});</listing>
		 */
		public static function setGlobalVolume(volume:Number, vars:Object = null):void {
			if (vars == null) vars = {};
			setTimeout(__updateGlobalVolume, vars.delay * 1000 || 0, volume, vars);
		}

		/**
		 * @private
		 */
		private static function __updateGlobalVolume(volume:Number, vars:Object):void {
			TweenLite.to(SoundMixer, vars.fadeTime || 0, {volume:volume});
		}

		private static var __internal_volume:Number;

		/**
		 * <p>Reproduce un sonido.</p>
		 *
		 * @see #resume()
		 * @see #pause()
		 * @see #stop()
		 * @see Audio#playAll()
		 *
		 * @param id Un identificador que, si existe, es igual al de la configuraci&oacute;n XML
		 * @param vars Un objeto con las propidades de reproducci&oacute;n del sonido.
		 *
		 * @return Un objeto de tipo <code>Audio</code>
		 *
		 * @example
		 * <listing version="3.0" >Audio.play("snd", {fadeTime: 1.5, volume: .7, position: 3.2});</listing>
		 */
		public static function playSnd(sound:Sound, vars:Object = null):AudioM {
			var sndMax:AudioM = new AudioM(sound);
			return sndMax.play(vars);
		}

		/**
		 * <p>Reproduce varios los sonidos al mismo tiempo.</p>
		 *
		 * @see Audio#playSnd()
		 * @see Audio#stopAll()
		 *
		 * @param vars Un objeto que define la reproducci&oacute;n de todos los sonidos.
		 *
		 * @return Un objeto array que contiene objetos de tipo <code>Audio</code>
		 *
		 * @example
		 * <listing version="3.0" >Audio.playAll([new SoundClass1(), new SoundClass2()], {fadeTime: 1.5, delay: 1.2, position: 10, volume: .8});</listing>
		 */
		public static function playAll(sounds:Array, vars:Object):Array {
			var l:uint = 0;
			var soundMaxs:Array = new Array();
			for (var i:uint = 0;i < l; i++) {
				var snd:AudioM = new AudioM(sounds[i] as Sound, "");
				soundMaxs.push(snd.play(vars));
			}
			return soundMaxs;
		}

		/**
		 * <p>Detiene la reproducci&oacute;n de todos los sonidos.</p>
		 *
		 * @see Audio#playSnd()
		 *
		 * @param vars {delay: 2.5, fadeTime: .5};
		 */
		public static function stopAll(vars:Object):void {
			var l:uint = __allAudio.length;
			for (var i:uint = 0;i < l; i++) {
				var snd:AudioM = __allAudio[i] as AudioM;
				snd.stop(vars);
			}
		}



		// // // // // // // // // // // ////////////////////
		// MISC
		// // // // // // // // // // // ////////////////////

		/**
		 * <p>Parsea un xml y define la configuraci&oacute;n.</p>
		 * <p><em>No es necesaria parsear una configuraci&oacute;n para utilizar la classe Audio.</em></p>
		 * <p>Si se especifica la configuraci&oacute;n de un sonido, identificable mediante <em>id</em>, cada vez que se reproduzca este se utilizar&aacute; la configuraci&oacute;n definida en el xml.</p>
		 *
		 * @param xml
		 *
		 * @example
		 * <listing version="3.0" >
		 * var xml:XML = &lt;soundmax volume='1'&gt;
		 * 		&lt;sound id="mySound1" /&gt;
		 * 		&lt;sound id="mySound2" fadeTime="2.5" /&gt;
		 * 		&lt;sound id="mySound3" volume=".75" /&gt;
		 * 		&lt;sound id="mySound3" loops="2" volume=".5" fadeTime="1.2" /&gt;
		 * &lt;/soundmax&gt;
		 *
		 * Audio.parseConfig(xml);</listing>
		 */
		public static function parseConfig(xml:XML):void {
			__config = xml;
			var globalVolume:Number = xml.@volume;
			AudioM.setGlobalVolume(globalVolume);
		}
	}
}