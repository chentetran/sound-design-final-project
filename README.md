# AI Random Song Generator

By Elli, Mina, 俞翔, 珮菱, Vincent ...

This website creates a random song with a unique melody, chord progression, bassline and drumline using our privileged music generation algorithms. You can pick your parameters to influence the sound of the song.

### Project plan
https://www.figma.com/file/H52Mb7AHBM1eYl0nFM80T6/Sound-Design-Final-Project-Plan?type=whiteboard&t=nxFoGnMj3ZmJcXFG-0

### Set up
Need to have `npm`, `node`, `chuck`, and `python3` (command needs to be python3. If your computer has python but not python3, you can change "python3" to "python" on line 36 in index.js) installed.

1. `npm install` to fetch dependencies.
2. `node index.js` to run.
3. Visit `http://localhost:3000` to see the UI.

### Overview

#### Endpoints

`/generate-music-notation` - Returns a JSON object of all the notes and note lengths for the chord progression, bassline, and melody

...



