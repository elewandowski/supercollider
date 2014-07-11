(
a = {
    var sound1 = LPF.ar(Saw.ar(80), 600) * EnvGate.new;
    var sound2 = RLPF.ar(Saw.ar(200) * 0.5, 6000 * EnvGate.new + 60, 0.1) * EnvGate.new;
    sound1 + sound2
}.play;
)
a.set(\fadeTime, 5);
a.release;

(
{
    var env = Env([0, 1, 0.5, 0.8, 0, 1.2, 0], [0.01, 0.5, 0.02, 0.5, 0.2, 0.5]);
    var gate = Impulse.kr(MouseX.kr(0.01, 3), 0.5);
    var gen = EnvGen.kr(env, gate);
    Out.ar(0, SinOsc.ar(270 * gen * MouseY.kr(1, 20)) * gen * 0.2 ! 2);
}.play
)

SynthDef(\lion, { |freq = 0|
	var envGate = Impulse.kr(MouseX.kr(0.1, 5), 0.5);
	var pitchEnv = EnvGen.kr(Env.sine(0.5, 1), envGate, doneAction: 2);
	var sig = Impulse.ar(freq + pitchEnv * 2) * 0.1;
	Out.ar(0, sig ! 2);
}).add

(
SynthDef(\env_help, { | out, gate = 0, freq = 440 |
    var z;
    z = EnvGen.kr(Env.perc, doneAction: 2) * SinOsc.ar(freq, 0, 0.25);
    Out.ar(out, z!2)
}).add;
)

{
	var out2 = LPF.kr(LFNoise2.kr(MouseX.kr(0, 2000)), LFNoise0.kr(1, 15000).abs);
	var out = SinOsc.ar(out2 * 2000, 0, 0.75);
	Out.ar(0, Pan2.ar(out, out2)) * 0.5;
}.play

fork {
    100.do {
        Synth(\lion, [\freq, 10.rand]);
        0.5.rand.wait;
    }
}

