MidiFileIn min;
// the MIDI message shuttle
MidiMsg msg;
// the filename
string filename;
// if no command line arguments provided
if( me.args() == 0 ) me.dir() + "MidiTest.mid" => filename;
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

int done;
2 => int UserInput; //1 creepy/ 2 water/ 3 video game

// for each track, spork a separate shred with the track number
if (UserInput ==1)
{  for( int t; t < min.numTracks(); t++ )
    spork ~ CreepFunc( t );

// keeping track of how many tracks are done
   while( done < min.numTracks() )
     1::second => now;

// done
 cherr <= "done; cleaning up..." <= IO.newline();
// close the file
   min.close();
}

if (UserInput ==2)
{  for( int t; t < min.numTracks(); t++ )
    spork ~ WaterFunc( t );

// keeping track of how many tracks are done
   while( done < min.numTracks() )
     1::second => now;

// done
 cherr <= "done; cleaning up..." <= IO.newline();
// close the file
   min.close();
}

if (UserInput ==3)
{  for( int t; t < min.numTracks(); t++ )
    spork ~ CreepFunc( t );

// keeping track of how many tracks are done
   while( done < min.numTracks() )
     1::second => now;

// done
 cherr <= "done; cleaning up..." <= IO.newline();
// close the file
   min.close();
}





// water sound function
fun void CreepFunc( int track )
{ if (track == 1) 
   {NRev reverb => dac;
    BlowHole s => reverb ;
    //800 => filter.freq;=> LPF filter
    0.2 => s.gain;
    0.05 => reverb.mix;
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
   if (track == 2)
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
       
  if (track == 3)
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

fun void WaterFunc( int track )
{ if (track == 1) 
   {NRev reverb => Echo echo => LPF filter => dac;
    ModalBar s => reverb ;
    600 => filter.freq;
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
   if (track == 2)
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
       
  if (track == 3)
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
    // done with track
    
    done++;
}


/* //// unused ideas or failed concepts//////////  

=> LPF filter
  800 => filter.freq;
fun void CaveFunc( int track )
{   NRev reverb => dac;
    SinOsc mod => SawOsc s => Echo echo => reverb ;
    100 => mod.freq;
    5 =>mod.gain;
    1 => s.gain;
    0.10 => reverb.mix;
    0.4 => echo.gain;
    0.15:: second => echo.max=> echo.delay;
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
        }*/         
