import axios from "axios";

const API = axios.create({
  baseURL: "https://captivating-achievement-production-7fbd.up.railway.app/api",
});

export default API;
