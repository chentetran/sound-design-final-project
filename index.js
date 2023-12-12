import express from "express";
import { fileURLToPath } from "url";
import path from "path";
import cors from "cors";
import { exec } from "node:child_process";
import fs from "fs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const port = 3000;

app.use(cors());

app.get("/", (req, res) => {
  res.sendFile("/assets/test13.html", { root: "." });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

const loadDrumline = async () => {
  const command = `chuck ${__dirname}/assets/Player.ck`;
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.error("errored");
    }
    console.log(`ChucK script output: ${stdout}`);
  });
};
app.get("/load-drumline", async (req, res) => {
  loadDrumline(res);
  res.send("OK");
});

const generateMusicNotation = (res) => {
  const command = `python3 ${__dirname}/musicGenerator.py`; // Needs to have python3 installed
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Internal Server Error" });
    }
    console.log(stdout);

    const outputFilePath = `${__dirname}/output_music_notation.json`;
    fs.writeFileSync(outputFilePath, stdout);

    console.log(`Output written to: ${outputFilePath}`);

    return JSON.parse(stdout);
  });
};
app.get("/generate-music-notation", (req, res) => {
  res.json(generateMusicNotation());
});

const convertToMidi = () => {
  const command = `python3 ${__dirname}/convert_to_midi.py output_music_notation.json`; // Needs to have python3 installed
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.error(err);
      return;
    }
    console.log(stdout);
  });
};
app.get("/convert-to-midi", (req, res) => {
  convertToMidi();
  res.send("cool");
});

const playMidi = (midiFile = "chord_progression.mid", env = "none") => {
  const command = `chuck ${__dirname}/play_midi.ck:${midiFile}:${env}`; // Needs to have python3 installed
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.error(err);
      return;
    }
    console.log(stdout);
  });
};
app.get("/play-midi", (req, res) => {
  playMidi();
  res.send("OK");
});

app.post("/generate-and-play-song", async (req, res) => {
  const env = req.query.environment;
  console.log(env);
  loadDrumline();
  generateMusicNotation();
  convertToMidi();
  playMidi("chord_progression.mid", env);
  playMidi("bassline.mid", env);

  res.send("done");
});

app.use("/assets", express.static(path.join(__dirname, "assets")));
