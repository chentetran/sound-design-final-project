class kjzSnare101 {
    // note: connect output to external sources to connect
    Noise s => Gain s_env => LPF s_f => Gain output; // white noise source
    Impulse i => Gain g => Gain g_fb => g => LPF g_f => s_env;
   
    3 => s_env.op; // make s envelope a multiplier
    s_f.set(3000, 4); // set default drum filter
    g_fb.gain(1.0 - 1.0/3000); // set default drum decay
    g_f.set(200, 1); // set default drum attack
   
    fun void setFilter(float f, float Q)
    {
        s_f.set(f, Q);
    }
    fun void setDecay(float decay)
    {
        g_fb.gain(1.0 - 1.0 / decay); // decay unit: samples!
    }
    fun void setAttack(float attack)
    {
        g_f.freq(attack); // attack unit: Hz!
    }
    fun void hit(float velocity)
    {
        velocity => i.next;
    }
}

class kjzBD101
{
   Impulse i; // the attack
   i => Gain g1 => Gain g1_fb => g1 => LPF g1_f => Gain BDFreq; // BD pitch envelope
   i => Gain g2 => Gain g2_fb => g2 => LPF g2_f; // BD amp envelope
   
   // drum sound oscillator to amp envelope to overdrive to LPF to output
   BDFreq => SinOsc s => Gain ampenv => SinOsc s_ws => LPF s_f => Gain output;
   g2_f => ampenv; // amp envelope of the drum sound
   3 => ampenv.op; // set ampenv a multiplier
   1 => s_ws.sync; // prepare the SinOsc to be used as a waveshaper for overdrive
   
   // set default
   80.0 => BDFreq.gain; // BD initial pitch: 80 hz
   1.0 - 1.0 / 2000 => g1_fb.gain; // BD pitch decay
   g1_f.set(100, 1); // set BD pitch attack
   1.0 - 1.0 / 4000 => g2_fb.gain; // BD amp decay
   g2_f.set(50, 1); // set BD amp attack
   .75 => ampenv.gain; // overdrive gain
   s_f.set(600, 1); // set BD lowpass filter
   
   fun void hit(float v)
   {
      v => i.next;
   }
   fun void setFreq(float f)
   {
      f => BDFreq.gain;
   }
   fun void setPitchDecay(float f)
   {
      f => g1_fb.gain;
   }
   fun void setPitchAttack(float f)
   {
      f => g1_f.freq;
   }
   fun void setDecay(float f)
   {
      f => g2_fb.gain;
   }
   fun void setAttack(float f)
   {
      f => g2_f.freq;
   }
   fun void setDriveGain(float g)
   {
      g => ampenv.gain;
   }
   fun void setFilter(float f)
   {
      f => s_f.freq;
   }
}


"none" => string environment;

NRev reverb => dac;
0.4 => reverb.mix;

// the MIDI file in object
MidiFileIn min;

// the MIDI message shuttle
MidiMsg msg;

// the filename
string filename;

// if no command line arguments provided
if (me.args() == 0) {
    me.dir() + "drum_line.mid" => filename;
}
// else use that filename
else {
    me.arg(0) => filename;
    me.arg(1) => environment;
}

// open the file; exit on error
if (!min.open(filename)) me.exit();

<<< min.numTracks() >>>;
// define a global variable for tracking done
0 => global int done;

// for each track, spork a separate shred with the track number
for (0 => int t; t < min.numTracks(); t++) {
    // explicitly pass the 'min' and 'reverb' objects
    spork ~ DrumFunc(t, min, reverb);
}

// keeping track of how many tracks are done
while (done < min.numTracks()) {
    1::second => now;
}

// close the file
min.close();

// entry point for each shred assigned to a track
fun void DrumFunc(int track, MidiFileIn @min, NRev @reverb) {
    MidiMsg msg;
    while (min.read(msg, track))
    {
        // this means no more MIDI events at the current time; advance time
        if (msg.when > 0::second)
            msg.when => now;

        
            if (msg.data2 == 34) // Note number for kick drum
            {
                kjzBD101 A;
                A.output => dac;
            }
            // Handle snare drum (example)
            else if (msg.data2 > 34)  // Note number for snare drum
            {
                // easy white noise snare
            kjzSnare101 A;
            A.output => dac;
            A.hit(0.8);
            2::second => now;
            A.setDecay(10000);
            A.setFilter(5000, 5);
            A.hit(0.8);
            2::second => now;
                            
            }
    }

    1 +=> done;
}