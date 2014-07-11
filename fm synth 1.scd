s.boot;

{Out.ar(0, SinOsc.ar(220, 0 ,0.4))}.play;

b = Buffer.alloc(s, "../sounds/222.aiff");
b.free;

{PlayBuf.ar(1, 0, 1)}.play;

(
// read a whole sound into memory
s = Server.local;
// note: not *that* columbia, the first one
b = Buffer.read(s,"sounds/a11wlk01.wav"); // remember to free the buffer later.
)

SynthDef("help_PlayBuf", { arg out=0,bufnum=0;
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum))
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);

SynthDef("help_PlayBuf", { arg out=0, bufnum=0;
	var trig;
	trig = Impulse.kr(MouseY.kr(0.5,200,1));
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, MouseX.kr(0, BufFrames.kr(bufnum)), 1)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);

SynthDef(\glob, {
	var notes = [1, 3, 7, 9];
	var n = 50;
	var modSig = Saw.kr(LFNoise1.kr(MouseX.kr(0,400)) * 50, 1);
	var ampSig = LFNoise1.kr(MouseY.kr(0, 4));
	var ampSigR = LFNoise1.kr(MouseY.kr(0, 4));
	//var envMod = EnvGen.kr(Env.linen(0.05, 0, 0.75), doneAction: 0) * 2;
	var carSig = Mix.fill(n, {
					arg index;
					SinOsc.ar(modSig * (1+index), 0.25) / n;
				}) * EnvGen.kr(Env.linen(3, 4, 3), doneAction: 2);

	Out.ar(0, carSig * ampSig);
	Out.ar(1, carSig * ampSigR);
}).play;

q = Routine({
		var delta=0;
		loop {
			Synth(\glob);
			delta.yield;
		}
});

r = Routine({
		var delta = rrand(0.1, 0.15), beat = 1;
		var bar = 4;
		var upDown = 2.rand;
		upDown.postln;
		
		loop {
				//4 bars of 16 beats, at the end: randomise tempo
				if ((beat > 32), {
					 beat = 1; 
					 bar = bar + 1;
				});

				if ((bar > 4), { 
					delta = rrand(0.1, 1);
					bar = 0;
					"4 bars have played".postln;
				});
				//count.postln;
				beat = beat + 1;
				

				if((upDown == 1), {
					Synth(\siny, [\freq, 200 + beat * 12]);
				}, {
					Synth(\siny, [\freq, 200 + 16 - beat * 12]);
				});

				delta.yield;
		}
});

TempoClock.default.sched(0, r);

SynthDef(\pop, {
	var freq = LFNoise1.kr(2, 200, 100);
	var amp = LFNoise1.kr(2);
	var pwm = LFNoise1.kr(MouseX.kr(0,2));
	var out = Pulse.ar(100 + freq, pwm, amp);
	Out.ar(0, Pan2.ar(out, LFNoise1.kr(2))) * 0.125;
}).add;

SynthDef(\siny, {
	|freq = 220|
//	var mod = Pulse.ar(freq/2, LFNoise1.kr(0.2));
	var mod = LFTri.ar(freq * MouseX.kr(0, 1.5)) * MouseY.kr(0, 5);
	var env = EnvGen.kr(Env.linen(0.05, 0, 0.2), doneAction: 2);
	var modEnv = EnvGen.kr(Env.linen(0.05, 0, 0.2));
	var out = (Saw.ar(freq * (mod * env)) * 0.25) * env;
	Out.ar(0, out ! 2);
}).add;

Synth(\pop);

{
	var i = 0;
	var list = [1, 2, 5, 3, 6, 12];
	var mySynth = Synth(\siny, \freq, midicps(list[i]));
	Out.ar(0, mySynth
}.play;

(
 a = 3;
 if (a == 3, {
  "true".postln;
 }, {
  "false".postln;
 });
)

(
SynthDef(\smooth, { |freq = 440, sustain = 1, amp = 0.5|
  var sig;
  sig = SinOsc.ar(freq, 0, amp) * 
      EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: 2);
  Out.ar(0, sig ! 2)
}).add;

p = Pbind(
    // the name of the SynthDef to use for each note
  \instrument, \smooth,
    // MIDI note numbers -- converted automatically to Hz
  \midinote, Pseq([60, 72, 71, 67, 69, 71, 72, 60, 69, 67], 2),
    // rhythmic values
  \dur, Pseq([2, 2, 1, 0.5, 0.5, 1, 1, 2, 2, 3], 1)
).play;
)

SynthDef(\subtr, {
		|freq, amp|
		var sig = WhiteNoise.ar() 
		- Mix.fill(10, {
					|index|
					SinOsc.ar(freq * (index * 0.5), 0, amp);
			});
		var ampEnv = EnvGen.kr(Env.linen(0.05, 0, 0.5), doneAction: 2);
		Out.ar(0, sig * ampEnv ! 2);
}).add;

(
var mousex = MouseX.kr(0, 300);
Synth(\subtr, [\freq, mousex, \amp, 0.3]);
)


