import {
  BarretenbergBackend,
  // BarretenbergVerifier as Verifier,
} from "@noir-lang/backend_barretenberg";
import { Noir } from "@noir-lang/noir_js";
import { JSONRPCClient } from "json-rpc-2.0";

import project from "../oracle_circuit/target/oracle_circuit.json" assert { type: "json" };

const client = new JSONRPCClient((jsonRPCRequest) => {
  return fetch("http://localhost:5555", {
    method: "POST",
    headers: {
      "content-type": "application/json",
    },
    body: JSON.stringify(jsonRPCRequest),
  }).then((response) => {
    if (response.status === 200) {
      return response
        .json()
        .then((jsonRPCResponse) => client.receive(jsonRPCResponse));
    } else if (jsonRPCRequest.id !== undefined) {
      return Promise.reject(new Error(response.statusText));
    }
  });
});

// declaring a function that takes the name of the foreign call (getSqrt) and the inputs
const foreignCallHandler = async (name, input) => {
  // notice that the "inputs" parameter contains *all* the inputs
  // in this case we to make the RPC request with the first parameter "numbers", which would be input[0]
  const oracleReturn = await client.request(name, [
    { Array: input[0].map((i) => i.toString("hex")) },
  ]);
  return [oracleReturn.values[0].Array];
};

async function main() {
  const backend = new BarretenbergBackend(project);
  const noir = new Noir(project, backend);

  const input = { input: [4, 16] };
  const { witness } = await noir.execute(input, foreignCallHandler);
  console.log(witness);

  // await setup();
  // console.log("Generating proof... ⌛");
  // TODO following line is giving error "triggerUncaughtException"
  // const proof = await noir.generateProof(input, foreignCallHandler);
  // console.log(proof);
  // console.log("Generating proof... ✅");
  // console.log(proof.proof);

  // console.log("Verifying proof... ⌛");
  // const verificationKey = await backend.getVerificationKey();
  // const verifier = new Verifier();
  // const isValid = await verifier.verifyProof(proof, verificationKey);
  // if (isValid) console.log("Verifying proof... ✅");
}

main();
