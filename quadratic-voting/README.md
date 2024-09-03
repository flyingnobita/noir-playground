# Quadratic Voting

## How to Run

### Use Noir version 0.30.0

```bash
noirup -v 0.30.0
```

### `user_circuit`: Generate the commitments for the circuit

```bash
cd user_circuit
# generate `user_circuit\Alice_Verifier.toml`
nargo prove -p Alice_Prover -v Alice_Verifier
# generate `user_circuit\Bob_Verifier.toml`
nargo prove -p Bob_Prover -v Bob_Verifier
```

### Prepare circuit inputs for ballot manager

Copy:

- the `secret` and `votes` from `user_circuit\Alice_Prover.toml` and `user_circuit\Bob_Prover.toml` to `ballot_manager_circuit\Prover.toml`
  - make sure the order of the votes, commitments and secrets are the same
- the "commitments" (`return`) from `user_circuit\Alice_Verifier.toml` and `user_circuit\Bob_Verifier.toml` to `ballot_manager_circuit\Prover.toml`

### `ballot_manager_circuit`: Generate the voting results for the ballot manager circuit

```bash
cd ballot_manager_circuit
# generate `ballot_manager_circuit\Verifier.toml`
nargo prove
```
