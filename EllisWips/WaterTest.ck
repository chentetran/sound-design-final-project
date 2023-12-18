
NRev reverb => dac;
// just a bit of reverb
//0.4 => reverb.mix;
// the MIDI file in object

MidiFileIn min;
// the MIDI message shuttle
MidiMsg msg;
// the filename
string filename;
// if no command line arguments provided
if( me.args() == 0 ) me.dir() + "bachtest2.mid" => filename;
// else use that filename
else me.arg(0) => filename;
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

// flag
SinOsc wat;
int done;


// for each track, spork a separate shred with the track number
for( int t; t < min.numTracks(); t++ )
    spork ~ WaterFunc( t );

// keeping track of how many tracks are done
while( done < min.numTracks() )
    1::second => now;

// done
cherr <= "done; cleaning up..." <= IO.newline();
// close the file
min.close();

/*
fun UGen instrument( int track)
{if(track ==0)
    {   Saxofony s;
    
     //1 => s.bodySize;
       return s ;
    }   
    if (track > 0)
    {   Mandolin s ;
   1 => s.bodySize;
        return s;
    } 
}
*/
// entry point for each shred assigned to a track
fun void WaterFunc( int track )
{   Wurley s => LPF filter => reverb ;
    400 => filter.freq;
    0.4 => s.gain;
    400 => wat.freq;
    10 => wat.gain;
    0.15 => reverb.mix;
        wat => s ;
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
 /*   
    if(track <= 0)
    {   Clarinet s;
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
        } 
    }   
    if (track > 0)
    {   Mandolin s ;
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
    // done with track
    */
    done++;
}

