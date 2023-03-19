# Clone, Build & Push tenableofficial/nessus to Docker Hub

A Github Action to:

- Clone [https://github.com/tenableofficial/nessus](tenableofficial/nessus)
- Build the Docker images
- Push to Docker Hub [https://hub.docker.com/r/mcnamee/nessus](mcnamee/nessus)

## Manually running the Dockerfile

```bash
# Build
docker build . -t mcnamee/nessus

# Run
docker run mcnamee/nessus
```
