s.boot;
s.quit;

~g = Group.new;

(
SynthDef(\daisy, {

	arg octMul, timing, filterAmount, repeatTime;

	var rhythm = Array.new(32);
	var sig, env, decay, filterEnv;

	var sines = 5;
	var base = 80;
	var nums = [1, 1.498, 1.122, 1.681, 1.189, 1.781];

	decay = EnvGen.kr(Env.linen(0.01, 0, timing, 1, 'wel'), Impulse.kr(repeatTime));
	sig = LFPulse.ar(base * octMul * nums, LFNoise1.kr(0.23).abs, 0.25) * 0.167 * decay;
	env = EnvGen.ar(Env.linen(0.05, 0, 16), doneAction: 2);

	sig = sig * env * 0.125;

	//lo-pass & hi-pass filter to make a bi-pass filter
	sig = RLPF.ar(sig, decay * 2000 + 20, 0.2); //lo-pass filter
	sig = RHPF.ar(sig, 1 - decay * 0.25 * 20000 + 20, 0.2);//hi-pass filter

	Out.ar(0, sig ! 2);

}).send(s);
)

(
t = Task({
	var waitTime;
	loop {
		Synth.new(\daisy, [\octMul, 2.pow(5.rand),//a;gklmadf;lkgm
					\timing, 0.5,
					\filterAmount, rrand(200, 5000),
					\repeatTime, [0.0625].choose]);
		waitTime = 2.pow(rrand(1,3))*0.25;
		waitTime.wait;
	}
}).play;
)

{SinOsc.ar(SinOsc.kr(MouseX.kr(1, 100), mul:MouseY.kr(1, 1000)), mul:0.1) ! 2}.play;
2.rand.post;
3.rand.post;

base, base+(base*16/9), base+(base*128/81), base+(base*3/2)

{exprand(1.0, 1000.0)}
(
{SinOsc.ar(340, 0, Decay2.ar(Impulse.ar(0.1),0.5, 0.125))}.play;


    