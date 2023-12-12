me.dir() => string path;
path + "E.wav" => string a_music;
<<<a_music>>>;
SndBuf my_player => dac;
a_music => my_player.read;

while(true){
    /* Math.random2(0, my_player.samples()) => int random_pos;
    random_pos => my_player.pos;   */
    0 => my_player.pos;
    0.5 => my_player.gain;
    /* Math.random2f(0, 1) => my_player.rate; */
    1 => my_player.rate;
    12::second => now;
}

