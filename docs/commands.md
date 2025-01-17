# Whacdamole Commands

## `whacdamole registry up {options}`

Start the local registry. Will base off the `.whacdamole` of the current directory. It should use `docker`.

* `--image registry:2` - Specifies what image to use for the registry.

## `whacdamole build`

Builds all of the specified Docker images, and push them to the specified registries. It should use `docker`.

## `whacdamole deploy`

Will deploy all specified Helm or Kustomize configurations. If there are git repo overrides, pull those repos somewhere and deploy from paths in those repos instead. It should use `helm` and `kubectl`.