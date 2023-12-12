import express from "express";
import { fileURLToPath } from "url";
import path from "path";
import cors from "cors";
import { exec } from "node:child_process";

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

app.get("/load-drumline", (req, res) => {
  const chuckScriptPath = __dirname + "/assets/Player.ck";
  const command = `chuck ${chuckScriptPath}`;
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.error("errored");
    }
    console.log(`ChucK script output: ${stdout}`);
  });
});

app.get("/generate-music-notation", (req, res) => {
  const pythonScriptPath = __dirname + "/musicGenerator.py";
  const command = `python3 ${pythonScriptPath}`; // Needs to have python3 installed
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Internal Server Error" });
    }
    console.log(stdout);
    return res.json(JSON.parse(stdout));
  });
});

app.use("/assets", express.static(path.join(__dirname, "assets")));
