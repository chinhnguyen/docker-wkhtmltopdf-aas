import { exec } from "child_process";
import express from "express";
import {
  temporaryWriteTask,
  temporaryFile,
  temporaryWrite,
  temporaryFileTask,
  temporaryWriteSync,
} from "tempy";

const app = express();
app.use(express.json());

app.get("/", (req, res) => {
  res.send("OK");
});

const convertHtmlToPdf = async (htmlFilePath, pdfFilePath, options) =>
  new Promise((resolve, reject) => {
    const optsParams = Object.keys(options)
      .map((k) => `--${k} ${options[k]}`)
      .join(" ");
    const cmd = `wkhtmltopdf ${optsParams} ${htmlFilePath} ${pdfFilePath}`;
    console.log(cmd);
    exec(cmd, (error, stdout, stderr) => {
      if (error) {
        reject(error);
        return;
      }
      // Somehow wkhtmltopdf is logging to stderr
      if (stderr) {
        console.error(`stderr: ${stderr}`);
      }
      if (stdout) {
        console.log(`stdout: ${stdout}`);
      }
      resolve();
    });
  });

app.post("/", (req, res) => {
  const { contents, options } = req.body;
  temporaryWriteTask(
    atob(contents),
    (htmlFilePath) =>
      temporaryFileTask(
        async (pdfFilePath) => {
          await convertHtmlToPdf(htmlFilePath, pdfFilePath, options);
          res.sendFile(pdfFilePath);
        },
        { extension: "pdf" }
      ),
    { extension: "html" }
  ).catch((err) => {
    console.error(err);
    res.status(500).send(err);
  });
});

app.listen(80, () => {
  console.log("Server running on port 80");
});
