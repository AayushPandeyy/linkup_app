// models/User.js
import { Schema as _Schema, model } from "mongoose";
import bcrypt from "bcrypt";
const Schema = _Schema;

const UserSchema = new Schema({
  email: { type: String, required: true, unique: true },
  username:{type : String , required: true, unique: true},
  password: { type: String, required: true },
});
UserSchema.pre("save", async function (next) {
  const user = this;
  if (!user.isModified("password")) return next();
  const hashedPassword = await bcrypt.hash(user.password, 10);
  user.password = hashedPassword;
  next();
});

UserSchema.methods.comparePassword = function (password) {
  return bcrypt.compare(password, this.password);
};

export default model("User", UserSchema);