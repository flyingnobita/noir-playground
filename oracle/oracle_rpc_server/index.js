import { JSONRPCServer } from "json-rpc-2.0";
import express from "express";
import bodyParser from "body-parser";

const app = express();
app.use(bodyParser.json());

const server = new JSONRPCServer();

server.addMethod("resolve_function_call", async (params) => {
  if (params.function !== "getSqrt") {
    throw Error("Unexpected foreign call");
  }
  const values = params.inputs[0].Array.map((field) => {
    return `${Math.sqrt(parseInt(field, 16))}`;
  });
  return { values: [{ Array: values }] };
});

app.post("/", (req, res) => {
  const jsonRPCRequest = req.body;
  server.receive(jsonRPCRequest).then((jsonRPCResponse) => {
    if (jsonRPCResponse) {
      res.json(jsonRPCResponse);
    } else {
      res.sendStatus(204);
    }
  });
});

app.listen(5555);
