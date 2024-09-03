# Quadratic Voting

## How to Run

### Use Noir version 0.31.0

```bash
noirup -v 0.31.0
```

### `user_circuit`: Execute Circuit

Execute circuit to get commitment and save:

- circuit to `target\user_circuit.json`
- witness to `target\Alice_Prover.gz` and `target\Bob_Prover.gz`

````bash
nargo execute -P Alice_Prover Alice_Prover
nargo execute -P Bob_Prover Bob_Prover
```

### Prepare circuit inputs for ballot manager

Copy:

- the `secret` and `votes` from `user_circuit\Alice_Prover.toml` and `user_circuit\Bob_Prover.toml` to `ballot_manager_circuit\Prover.toml`
  - make sure the order of the votes, commitments and secrets are the same
TODO Get the commitments in hex from `user_circuit`
- the "commitments" (`return`) from `user_circuit\Alice_Verifier.toml` and `user_circuit\Bob_Verifier.toml` to `ballot_manager_circuit\Prover.toml`

### `ballot_manager_circuit`: Generate the voting results for the ballot manager circuit

```bash
cd ballot_manager_circuit
# generate `ballot_manager_circuit\Verifier.toml`
nargo prove
````
