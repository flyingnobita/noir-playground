# Oracle

## How to Run

### Use Noir version 0.31.0

```bash
noirup -v 0.31.0
```

### Start Oracle RPC Server

```bash
cd oracle_rpc_server
npm run start
```

### Compile Oracle Circuit into ACIR

```bash
cd oracle_circuit
nargo compile
```

### Run User App

```bash
npm start
```
