import express from "express";

import connection from "./database/connection.js";
import authRouter from "./routes/AuthRoute.js";
import dotenv from "dotenv";

dotenv.config();

const app = express();

connection();

app.use(express.json());
app.get("/", (req, res) => res.send("Working"));

app.use("/api/auth", authRouter);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
