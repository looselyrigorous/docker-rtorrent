# Kubernetes Resources

This directory contains a deployment for Kubernetes.

Check all the `TODO`s before you deploy it:

```sh
grep -r "TODO" .
```

## Running multiple replicas

This example only works with one replica on a single-node cluster. If you want
to have multiple replicas, on multiple hosts, you will need to use the according
storage options, most likely a `PersistentVolume`.
