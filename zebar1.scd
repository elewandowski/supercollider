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
}).send(s);
)

(

//f = SinOsc.kr(1, mul:2000);
f = 100;
//{Poll.kr(Impulse.kr(1), f)}.play;

t = Task({

	var mx = MouseX.kr(30, 3000);
	//s = Synth(\zebar, []);
	

	loop{
		//s.set(\freq, mx);
		s = Synth(\zebar, [\freq, 2]);
		0.2.rand.wait;	
	}
}).play;
)

20.do{
	
	Synth(\zebar, [\freq, 2]);
}

a = SinOsc.kr(0.1, mul:2000);
~g = 2
Env.perc(0.001, 1, 1, -32).test.plot;    // sharper attack  

(
a = {
	r = LFNoise0.kr(1, mul:1000);
	Poll.kr(Impulse.kr(1), r);
	//FreeSelf.kr(r <= 0);
	0
}.play;
)    