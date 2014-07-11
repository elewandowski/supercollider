s.boot;

//control----------------------
(
var sequenceSize = 32;
var time = 0.25;
var result;
var ratios = Array.newFrom(Set[0, 1, 3, 4, 6, 8, 10, 12]);
var a = Array.newClear(sequenceSize);
var myF = {
	for(0, 31, {arg i;
		a.put(i, ratios[8.rand]);
	});
	a;	/*	this line returns the randomized array as sc doesn't need "return"
			otheriwse we are only returning the result of the "for" loop
			which would be 0 or 1
		*/
};
for(0,2, {	
	result = result ++ myF.();
});
t = Task({
	var synthFreq = 0, bars = 0;
	var waitTime;
	loop {
		waitTime = LFNoise0.kr(0.2).abs;
		if( synthFreq == 32, {
			"END OF LOOP".postln;
			bars = bars + 1;
		
			if( bars == 4 , {
				"END OF PHRASE".postln;
				result = result.scramble;
			});
		});
		Synth(\blipp, [\freq, result[synthFreq] * 25 * 5, \ti, time]);
		synthFreq = synthFreq + 1 % (sequenceSize*2);
		(time * 0.25).wait;
	}
}).play;
)

//synthesis--------------------
(
SynthDef(\blipp, { 
	arg  freq = 0, ti = 1, modAmp = 20.0.rand;

	var amp, out, trigger, env, poll, vibrato, mod, freqMod;
	
	//amp = LFNoise1.kr(0.4);	
	//trigger = SendTrig.kr(amp > 0.5, 0, 1).poll;
	env = EnvGen.ar(Env.triangle(ti*2), doneAction: 2);
	//ampMod = LFTri.ar(8.0.rand, 0, 1.0.rand);
	freqMod = SinOsc.kr(rrand(100, 400), 0, rrand(10, 40));
	vibrato = SinOsc.kr(7.0.rand, 0, 10.0.rand);

	out = SinOsc.ar((freq + vibrato) * freqMod, 0, 0.25) * env;
	//out = DelayL.ar(out, 0.5, delaytime: 0.2, mul: 1, add: 0);
	//out = LPF.ar(out, LFNoise1.kr(1, 10000, 20).abs);

	Out.ar(0, Pan2.ar(out, LFNoise1.kr(0.25)));
}).send(s);
)

SynthDef(\ra, {
	arg fre;

	var freq = rrand(440, 880);
	var env = EnvGen.kr(Env.linen(0.01, 8, 0.01), doneAction: 2);

	Out.ar(0, SinOsc.ar(fre, 0 , 0.1 * env) ! 2);
}).send(s);

Task({

	loop{
		Synth(\ra, [\fre, rrand(440,880)]);
		2.wait;
	}
}).play;

(
play {
    var t = PulseCount.ar(Impulse.ar(8e3));
    HPF.ar(
        (
            ((t * 15) & (t >> 5)) |
            ((t * 5)  & (t >> [3, 4])) |
            ((t * 2)  & (t >> 9)) |
            ((t * 8)  & (t >> 11))
            - 3 % 256
        ) / 127-1 * 3
        , 10
    ).tanh
}
)



s.quit;          
