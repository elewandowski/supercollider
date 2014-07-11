play({SinOsc.ar(440, 0.2)})

play({
	var pitch, amp;
	Mix.fill(2, SinOscFB.ar(440, 0.2))

})

s.boot;

f = {arg a, b; a * 20 * b}

f.value(254, 20);

{
 	var ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
    SinOsc.ar(440, 0, ampOsc);

}.play;


(
var notes = [10.rand, 10.rand, 10.rand, 10.rand];

x = {
var amp = Saw.kr(MouseX.kr);
var pitch = Saw.kr(MouseY.kr, 200, 50);

//for (3, 7, { arg i; i.postln });

d = Mix.fill(4, {
			arg index;
			var ran = 0;
			var ran2 = 2.rand;
			notes[index].postln;
			[SinOsc.ar(pitch * notes[index], amp*ran2), SinOsc.ar(pitch*2.1 + ran, amp*ran2)] * 0.125 });

Out.ar(0, d ! 2);
}.play;
MouseX.kr.postln;
)


x.play;
x.free;

(
  SynthDef(\smooth, { |freq = 440, sustain = 1, amp = 0.5|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * 
        EnvGen.kr(Env.perc(0.05, sustain, 0.1), doneAction: 2);
    Out.ar(0, sig ! 2)
  }).add;
)

Synth(\smooth, [\freq, 300, \sustain, 0.3, \amp, 0.45]);


r = Routine({
    var delta;
    loop {
      delta = rrand(1, 3) * 0.5;
      Synth(\smooth);
      delta.yield; //yield and return this value
    }
  });

r.next;
TempoClock.default.sched(0, r);
r.stop;


SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
	var	sig;
	var n = 3;
	sig = Mix.fill(n, 
        {
          arg index;
          var freq;
		MouseX.kr(0.0, 1.0).poll;
          freq = 440 + (440 * (index * MouseX.kr(0.0, 1.0)));
          SinOsc.ar(freq , 0, 1 / n);
        }
      ) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
	Out.ar(0, sig ! 2);	// sig ! 2 is the same as [sig, sig]
}).play(s);


r = Routine({
	var	delta;
	loop {
		delta = 0.25;
		Synth(\singrain, [freq: exprand(200, 2000), amp: rrand(0.1, 0.5), sustain: delta * 0.8]);
		delta.yield;
	}
});

{
MouseX.kr(0, 100).poll;
}

SynthDef(\wobbly, { |base = 440, amp = 0.3|
	var freq = Array.new(3);
	out = Mix.fill( 3, {
		arg index;
		SinOsc.ar(freq[index], amp);
		})
	Out.ar(0, out ! 2);
})

)
{ Saw.ar(XLine.kr(40,4000,6),0.2) }.play;

play({ Klang.ar(`[ Array.rand(12, 600.0, 1000.0), nil, nil ], 1, 0) * 0.05 });

(
{
loop({
    play({
        Pan2.ar(Klang.ar(`[ Array.rand(12, 200.0, 2000.0), nil, nil ], 1, 0), SinOsc.kr(2.0.rand, 1))
            * EnvGen.kr(Env.sine(8), 1, 0.02, doneAction: 2);
    });
    8.wait;
})
}.fork;
)


{
out = SinOsc.ar(GbmanN.ar(100)*800+500)*0.4);
Mix.ar(0, out ! 2);
}
)

