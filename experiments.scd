s.boot; 
s.options.numOutputBusChannels = 16;
s.quit;
( 
p = Pbind( 
\degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1), 
\dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1) 
).play; 
) 

SynthDef("sine", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).send(s);  
s.sendMsg("s_new", "sine", n = s.nextNodeID, 0, 1); 

{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play; 


(
{
var p, xx, yy;

p = {
	var sines = 16, speed = 6; r = MouseX.kr(0.1,100);
	y = MouseY.kr(0.1, 1.0);
	Mix.fill(sines,
		{arg x;
			Pan2.ar(
				SinOsc.ar(x+1*r,
					mul: max(0,
						LFNoise1.kr(speed*y)
						//Line.kr(1, -1, 60)
					)
				), rand2(1.0))})/sines};
xx = FreeVerb.ar(p, 1, 1, 0, 0.5, 0);
yy = FreeVerb.ar(xx, 1, 1, 0, 1, 0);

}.play;
)

p.free
p.play

x = { 

SinOsc.ar(SinOsc.kr(20,0,1)*MouseX.kr(1/3,300)+100, 0,
	SinOsc.kr(0.01*MouseY.kr(1,100))*0.2)}.play; 

x.play;
x.free

( 
{ 
// play with the room size 
var x; 
x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1)); 
GVerb.ar(x, 105, 5, 0.7, 0.8, 60, 0.1, 0.5, 0.4) + x; 
}.scope; 
) 
 
{(Dust.ar(1,0.5)}.play;

{ CombN.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.scope(1, zoom:4); 

( 
{ 
// play with the room size 
var x; 
x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1)); 
x = Pan2.ar(x, -0.2); 
x = [x[0], DelayC.ar(x[1], 0.01, 0.01)]; // de-correlate 
FreeVerb.ar(x, 0.75, 0.9, 0.4); 
}.scope; 
)    

b = Buffer.read(s, "sounds/a11wlk01.wav"); 
( 
{ 
var trate, dur; 
trate = MouseY.kr(2,200,1); 
dur = 4 / trate; 
TGrains.ar(2, Impulse.ar(trate), b, 1, MouseX.kr(0,BufDur.kr(b)), dur, 0, 0.1, 2); 
}.scope(2, zoom: 4); 
) 

( 
{ 
var trate, dur, clk, pos, pan; 
trate = MouseY.kr(8,120,1); 
dur = 12 / trate; 
clk = Impulse.kr(trate); 
pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk); 
pan = WhiteNoise.kr(0.6); 
TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1); 
}.scope(2, zoom: 4); 
) 

{SinOsc.ar(440,0,0.5);}

( // using default window 
{ 
var trigrate, winsize, trig; 
trigrate = MouseX.kr(2, 120); 
winsize = trigrate.reciprocal; 
trig = Impulse.ar(trigrate); 
GrainSin.ar(2, trig, winsize, TRand.ar(440.0, 880.0, trig), LFNoise1.kr(0.2), 
-1, 0.2) 
}.scope(2, zoom: 4); 
)  