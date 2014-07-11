s.boot;

(
SynthDef(\zebar, {
	arg freq;
	var sig, env, filEnv;
	
	freq = freq + LFNoise1.kr(0.25, 40, 200).abs;
	env = EnvGen.kr(Env.linen(0.01, 0, 1), doneAction: 2);
	filEnv = EnvGen.kr(Env.perc(0.1, 0.5, curve: -1));
	sig = LFSaw.ar(freq, 0, 0.1);
	sig = BLowPass4.ar(sig, filEnv * MouseX.kr(20000) + 20, 0.01) * 0.02;

	Out.ar(0, sig ! 2);
}).play(s);
)

(
t = Task({

	//var mx = MouseX.kr(30, 3000);
	loop{
		Synth(\zz, [\choice, int(12.rand)]);
		1.0.rand.wait;
	}
}).play;
)

(
SynthDef(\zz, {
	arg baseF = 100, speed = 1, choice = 0;
	var sig, env, time, freq, mul, scale;
	scale = [1, 1 + (1/12)*2, 1 + (1/12)*4, 1 + (1/12)*5, 1 + (1/12)*7, 1 + (1/12)*9, 1 + (1/12)*11];
	
	//e = Env([2, 4, 3, 4, 1], [1, 3, 4, 1], releaseNode:5, loopNode: 1);
	//time = EnvGen.kr(e, 1 - Impulse.kr(0.25), timeScale: 8);

	speed = MouseX.kr(0, 20);
	env = EnvGen.kr(Env.linen(0.01, 0, 1.0/(speed)), Impulse.kr(speed));
	mul = scale.choose;
	sig = SinOsc.ar(baseF * scale[choice], mul:env * 0.25 * 0.167);
	Out.ar(0, sig!2);
}).play(s);
)

Env.perc(0.001, 1, 1, -32).test.plot;    // sharper attack  

{Impulse.ar(1)}.play 