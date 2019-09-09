# Kubernetes Resources

This directory contains a deployment for Kubernetes.
It runs `rtorrent` and `Flood` in a Pod, making `Flood` available through an
ingress resource and `rtorrent` through a LoadBalancer (for being connectable).

Check all the `TODO`s before you deploy it:

```sh
grep -r "TODO" .
```

## Running multiple replicas

This example only works with one replica on a single-node cluster. If you want
to have multiple replicas, on multiple hosts, you will need to use the according
storage options, most likely a `PersistentVolume`.
