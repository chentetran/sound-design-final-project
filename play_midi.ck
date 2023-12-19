"none" => string environment;

MidiFileIn min;
// the MIDI message shuttle
MidiMsg msg;
// the filename
string filename;
// if no command line arguments provided
if( me.args() == 0 ) 
{"chord_progression.mid" => filename;
"none" => environment;
}// else use that filename
else {
    me.arg(0) => filename;
    me.arg(1) => environment;
}
// open the file; exit on error
if( !min.open(filename) ) me.exit();

// print out 
cherr <= "----------" <= IO.newline();
cherr <= "MIDI file: " <= IO.newline()
      <= " |- " <= filename <= IO.newline()
      <= " |- contains " <= min.numTracks() <= " tracks" <= IO.newline();
// print
cherr <= "----------" <= IO.newline();
cherr <= "playing..." <= IO.newline();
cherr <= "----------" <= IO.newline();

<<< min.numTracks()>>>;

int done;

// for each track, spork a separate shred with the track number
for( int t; t < min.numTracks(); t++ ) {
    if (environment == "underwater") {
        spork ~ WaterFunc( t );
    } else if (environment == "spooky") {
        spork ~ CreepFunc( t );
    } else if (environment == "videogame") {
        spork ~ GameFunc( t );
    } else if (environment == "none"){
        spork ~ NoneFunc( t );
        // TODO implement "none"
    }
}

// keeping track of how many tracks are done
while( done < min.numTracks() )
    1::second => now;

// done
cherr <= "done; cleaning up..." <= IO.newline();
// close the file
min.close();

fun void WaterFunc( int track )
{ if (filename == "melody.mid") 
   {NRev reverb => Echo echo => LPF filter => dac;
    ModalBar s => reverb ;
    500 => filter.freq;
    4 => s.gain;
    0.2 => reverb.mix;
    1.5 => echo.gain;
    0.1:: second => echo.max=> echo.delay;
        //wat => s ;
    while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
            // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
            // get the pitch and convert to frequencey; set
            msg.data2 => Std.mtof => s.freq;
            // velocity data; note on
            msg.data3/127.0 => s.noteOn;
            cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
         }
     } 
   if (filename == "chord_progression.mid")
    {   NRev reverb => Echo echo => LPF filter =>  dac;
        500 => filter.freq;
        0.05 => reverb.mix;
        ModalBar s ;
        
        2 => echo.gain;
        0.06:: second => echo.max=> echo.delay;
        2 => s.gain;
        s => reverb;
    
        while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
        // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
                // get the pitch and convert to frequencey; set
                msg.data2 => Std.mtof => s.freq;
                // velocity data; note on
                msg.data3/127.0 => s.noteOn;
                cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
        // other messages
            else
            {
            // log
            // cherr <= "----EVENT (unhandled) track:" <= track <= " type:" <= (msg.data1&0xF0)
            //      <= " data2:" <= msg.data2 <= " data3:" <= msg.data3 <= IO.newline(); 
            }
    
        }
    }
       
  if (filename == "bassline.mid")
   {   NRev reverb => dac;
       0.10 => reverb.mix;
       Shakers s ;
       22 => s.preset;
       0.5 => s.gain;
        s => reverb;
    
        while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
        // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
                // get the pitch and convert to frequencey; set
                msg.data2 => Std.mtof => s.freq;
                // velocity data; note on
                msg.data3/127.0 => s.noteOn;
                cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
        // other messages
            else
            {
            // log
            // cherr <= "----EVENT (unhandled) track:" <= track <= " type:" <= (msg.data1&0xF0)
            //      <= " data2:" <= msg.data2 <= " data3:" <= msg.data3 <= IO.newline(); 
            }
    
        }
    }
    done++;
}

fun void CreepFunc( int track )
{ if (filename == "melody.mid") 
   {NRev reverb => dac;
    BlowHole s => reverb ;
    //800 => filter.freq;=> LPF filter
    0.1 => s.gain;
    0.1 => reverb.mix;
    //0 => echo.gain;=> Echo echo
   // 0.10:: second => echo.max=> echo.delay;
        //wat => s ;
    while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
            // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
            // get the pitch and convert to frequencey; set
            msg.data2 => Std.mtof => s.freq;
            // velocity data; note on
            msg.data3/127.0 => s.noteOn;
            cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
         }
     } 
   if (filename == "chord_progression.mid")
    {   NRev reverb => dac;
        0.05 => reverb.mix;
        Mandolin s ;
        1 => s.bodySize;
        0.2 => s.gain;
        s => reverb;
    
        while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
        // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
                // get the pitch and convert to frequencey; set
                msg.data2 => Std.mtof => s.freq;
                // velocity data; note on
                msg.data3/127.0 => s.noteOn;
                cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
        // other messages
            else
            {
            // log
            // cherr <= "----EVENT (unhandled) track:" <= track <= " type:" <= (msg.data1&0xF0)
            //      <= " data2:" <= msg.data2 <= " data3:" <= msg.data3 <= IO.newline(); 
            }
    
        }
    }
       
  if (filename == "bassline.mid")
   {   NRev reverb => dac;
       0.10 => reverb.mix;
       BandedWG s ;
       3 => s.preset;
       0.2 => s.gain;
        s => reverb;
    
        while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
        // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
                // get the pitch and convert to frequencey; set
                msg.data2 => Std.mtof => s.freq;
                // velocity data; note on
                msg.data3/127.0 => s.noteOn;
                cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
        // other messages
            else
            {
            // log
            // cherr <= "----EVENT (unhandled) track:" <= track <= " type:" <= (msg.data1&0xF0)
            //      <= " data2:" <= msg.data2 <= " data3:" <= msg.data3 <= IO.newline(); 
            }
    
        }
    }
    // done with track
    
    done++;
}

fun void GameFunc( int track )
{     PulseOsc osc1 => Gain g => ADSR env => dac;
        TriOsc osc2 => g;
        Noise osc3 => LPF lpf => g;
        //1200 => lpf.freq;
        0.4 => osc1.gain;
        0.2 => osc2.gain;
        0.2 => osc3.gain;
        0.2 => g.gain;
       // (1::ms, 8::ms , 0.2, 1::ms) => env.set;
        
    while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
            // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
            // get the pitch and convert to frequencey; set
            
            msg.data2 => Std.mtof => osc1.freq;
            msg.data2 => Std.mtof => osc2.freq;
            msg.data2 => Std.mtof => float nf;
            nf*4 => lpf.freq;
            // velocity data; note on
            float duration;
            msg.data3/127.0 => duration;
            //<<< duration>>>;
            (1::ms, duration::second, 0, 1::ms) => env.set;
             1 => env.keyOn;
        
             //duration::second => now;

            cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
         }
     
    // done with track
    
    done++;
}

fun void NoneFunc( int track )
{ if (filename == "melody.mid") 
   {    NRev reverb => dac;
        SinOsc s => ADSR env => reverb ;
        0.1 => s.gain;
        0.1 => reverb.mix;
    while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
            // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
            // get the pitch and convert to frequencey; set
            msg.data2 => Std.mtof => s.freq;
             float duration;
            msg.data3/127.0 => duration;
            //<<< duration>>>;
            (50::ms, duration::second, 1, duration::second) => env.set;
             1 => env.keyOn;
            cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
         }
     } 
   if (filename == "chord_progression.mid")
    {   NRev reverb => dac;
        SawOsc saw => ADSR env => reverb ;
        0.2 => saw.gain;
        0.5 => reverb.mix;
    while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
            // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
            // get the pitch and convert to frequencey; set
            msg.data2 => Std.mtof => saw.freq;
             float duration;
            msg.data3/127.0 => duration;
            //<<< duration>>>;
            (0::ms, duration::second, 0, duration::second) => env.set;
             1 => env.keyOn;
            cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
         }
    }
       
  if (filename == "bassline.mid")
   {  //NRev reverb => dac;
        SinOsc saw => ADSR env => dac;
        0.2 => saw.gain;
        //0.1 => reverb.mix;
    while( min.read( msg, track ) )
        {
            // this means no more MIDI events at current time; advance time
            if( msg.when > 0::second )
                msg.when  => now; // this could be used to change speed 
        
            // catch NOTEON messages (lower nibble == 0x90)
            if( (msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0 )
            {
            // get the pitch and convert to frequencey; set
            msg.data2 => Std.mtof => saw.freq;
             float duration;
            msg.data3/127.0 => duration;
            //<<< duration>>>;
            (0::ms, duration::second, 0.2, 0::ms) => env.set;
             1 => env.keyOn;
            cherr <= "NOTE ON track:" <= track <= " pitch:" <= msg.data2 <=" velocity:" <= msg.data3 <= IO.newline(); 
            }
         }
    }
    // done with track
    
    done++;
}