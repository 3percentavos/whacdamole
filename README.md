<div align="center">
    <img alt="Whacdamole logo" src="docs/logo.png" width="600">
</div>


**Whacdamole** is a single Python script that acts as a Kubernetes CD operator and CLI tool for Kubernetes app development. Whacdamole automates Docker image builds, Helm and Kustomize deployments, and a quick way to verify on Kubernetes with an accessible registry.

At some point I realised that I didn't want to have to build and deploy a hundred different projects to just verify a single application on Kubernetes. I decided to make this monstrosity to try and pack everything into yet-another-yaml-config that covers probably most of what you'd need to prototype an app for Kubernetes (hence Whackamole).

## Prerequisites 🚚

Before using Whacdamole, ensure you have the following installed:

- **Kubernetes Cluster**: Access to a Kubernetes cluster.
    - **Helm**: Installed for deploying Helm charts.
    - **Kubectl**: Installed for interacting with Kubernetes.
- **Docker**: Installed and configured for building images.
- **Python 3.12+**: Required if running the CLI tool from source. The following packages are used.
    - `ruamel.yaml==0.17.21`
    - `kubernetes==31.0.0`
- **Git**: For cloning repositories.

## Installation 🏗️

### Using Docker

Whacdamole can be containerised using Docker. This approach encapsulates all dependencies, ensuring consistency across environments.

1. **Build the Docker Image**

   ```bash
   docker build -t whacdamole:latest .
   ```

2. **Run the Docker Container**

   ```bash
   docker run --rm -it whacdamole:latest --help
   ```

### From Source

For those who prefer running Whacdamole directly from the source:

1. **Clone the Repository**

   ```bash
   git clone https://github.com/3percentavos/whacdamole.git
   cd whacdamole
   ```

2. **Install Python Dependencies**

   ```bash
   pip install -r requirements.txt
   ```

3. **Make the Script Executable**

   ```bash
   chmod +x whacdamole
   ```

4. **Add to PATH (Optional)**

   ```bash
   sudo mv whacdamole /usr/local/bin/
   ```

### Deploy the Kubernetes operator

This is experimental! If you're using this as an actual CD solution, install it on Kubernetes. This assumes you have already installed whacdamole.


1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/whacdamole.git
   cd whacdamole
   ```

2. **Deploy [`.whacdamole`](.whacdamole)**

   ```bash
   ./whacdamole deploy
   ```

## Usage 💻

Whacdamole provides a command-line interface (CLI) with several subcommands to manage your Kubernetes resources efficiently.

### Configuration

Whacdamole relies on a `.whacdamole` YAML configuration file located in the current directory. This file defines project details, Docker images, and deployment configurations.

**Example `.whacdamole` Configuration:**

```yaml
apiVersion: whackdamole.github.com/v1beta
kind: Whacdamole
metadata:
  name: my-project
spec:
  name: MyProject
  version: "1.0.0"
  gitRepo: https://github.com/example/my-project.git
  branchToWatch: main
  localEnvironment:
    enableLocalKubernetes: true
    enableLocalDockerRegistry: true
    localDockerRegistryPort: 5000
    localDockerRegistries:
      - "http://my-registry.local:5000"
    kubeconfig: "/home/user/.kube/config"
  dockerImages:
    - name: backend
      tags:
        - "0.0.1"
        - "latest"
      registry: docker.io/myrepo
      directory: ./services/backend
    - name: frontend
      tags:
        - "0.0.1"
        - "latest"
      registry: docker.io/myrepo
      directory: ./services/frontend
  helmDeployments:
    - gitRepo: https://github.com/example/helm-charts.git
      branchToWatch: release
      chartPath: charts/mychart
      values: |
        replicaCount: 2
        image:
          repository: myrepo/backend
          tag: "0.0.1"
      overrides:
        environment: production
        debug: "false"
  kustomizeDeployments:
    - gitRepo: https://github.com/example/kustomize-configs.git
      branchToWatch: develop
      kustomizePath: overlays/production
```

When needing to pull an image from the local registry when deploying Kustomize manifests or Helm Charts to the the local Kubernetes cluster, point to `whacdamole.registry`.

### CLI Commands

#### `whacdamole registry up {options}`

**Description:**  
Start the local Docker registry based on the `.whacdamole` configuration in the current directory using Docker.

**Options:**

- `--image registry:2`  
  Specifies which Docker image to use for the registry. Defaults to `registry:2` if not provided.

**Usage:**

```bash
whacdamole registry up --image registry:2
```

#### `whacdamole build`

**Description:**  
Builds all Docker images defined in the `.whacdamole` configuration and pushes them to the specified registries using Docker.

**Usage:**

```bash
whacdamole build
```

#### `whacdamole up`

**Description:**  
Deploys all specified Helm charts and Kustomize configurations. If there are Git repository overrides, Whacdamole pulls those repositories and deploys from the specified paths using Helm and kubectl. This will also spin up a registry and a Kubernetes cluster if specified.

**Usage:**

```bash
whacdamole up
```

**Note:**  
Ensure that this command is executed in an environment with access to the Kubernetes API server, typically from within a Kubernetes cluster.

#### `whacdamole down`

**Description:**  
Tears down all specified Helm charts and Kustomize configurations. This will also tear down the associated Kubernetes cluster and Docker registry if specified.

**Usage:**

```bash
whacdamole down
```

**Note:**  
Ensure that this command is executed in an environment with access to the Kubernetes API server, typically from within a Kubernetes cluster.

## Roadmap 🛣️

- [x] Docker registry.
- [x] Docker builds.
- [x] `k3s` or another Kubernetes deployment with insecure registries.
- [x] Helm and Kustomize deployment.
- [ ] GitOps.
- [ ] Look into using `cltptl` resources or similar.
- [ ] Look into tilt dev integration.

## License 📜

Whacdamole is released under the [MIT License](LICENSE). The Whacdamole graphic is released by 3percentavos with a [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/).
