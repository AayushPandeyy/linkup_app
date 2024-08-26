import mongoose from "mongoose";

const connection = async () => {
  try {
    await mongoose.connect("mongodb://127.0.0.1:27017/chatapp_flutter");
    console.log("Connected to the database");
  } catch (error) {
    console.log("Error connecting to the database");
  }
};
export default connection;
