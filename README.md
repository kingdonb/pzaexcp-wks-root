This repo points at other repositories which are related container images, built using the Makefile included in this directory.

You are on the master branch of `git@github.com:kingdonb/pzaexcp-wks-root.git`.

This is a map to the child repos and instruction for how to prepare for the `make build` (you can run `make clone` or copy and paste this):

```
git clone git@bitbucket.org:nd-oit/pzaforms.git \
  -b frontend-dockerfile    pzaexcp-frontend;
git clone git@bitbucket.org:nd-oit/pzaforms.git \
  -b pzaforms-api-docker    pzaexcp-api;
git clone git@bitbucket.org:nd-oit/nd_hrpy_api_internal.git \
  -b hrpy-dockerfile        hrpy-api;
git clone git@bitbucket.org:nd-oit/nd-person-api-ws.git \
  -b person-api-dockerfile  person-api;

```

The images are tagged for push to a local/private repo, for use in CI or with local or air-gapped testing environments.  The registry is expected to be hosted at localhost:5000 on your workstation, and is addressed from within Docker or Footloose by the bridge IP of the private registry container. Typing `make build push` will build and push images called:

```
localhost:5000/pzaexcp-frontend:latest
localhost:5000/pzaexcp-api:latest
localhost:5000/hrpy-api:latest
localhost:5000/person-api:latest
```

You should update REGISTRY_IP and/or REGISTRY_PORT in the Makefile to reflect correct information regarding how the registry is addressed from inside of your cluster before running `make manifest`, which outputs deployments and services for the apps above into a constellation. The deployments will be created in the `pzaexcp` namespace, and are configured so that frontends can discover backends normally through their service objects.

```
kubectl apply -f pzaexcp-constellation.yaml
```

The `make secrets` command is not yet written, so users will need to make and bind secrets separately, (or simply disable authentication between `clone` and `build`, which is a totally reasonable approach since this is meant to be an air-gapped configuration.)

Frequently Asked Questions (FAQ):

Q: if you get the error,

```
ArgumentError: Missing `secret_key_base` for 'production' environment, set this string with `rails credentials:edit`
```

A: Go ahead and `cd` into the cloned `pzaexcp-frontend` directory and generate a new master key as it says, (the credentials file is not yet used, so this is a throwaway key)

```
EDITOR=vim rails credentials:edit
```
