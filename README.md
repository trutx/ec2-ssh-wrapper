# ec2-ssh-wrapper

SSH wrapper to convert EC2 private DNS names into IPs.

## Motivation

There's probably other use cases but mine is simple: I grew tired of having to hand edit EC2 private DNS names to `ssh` into them.

`kubectl get nodes` outputs a list of Kubernetes node names and status. If the cluster is composed of AWS EC2 instances the output looks like:

```sh
$ kubectl get nodes
NAME                                           STATUS   ROLES    AGE     VERSION
ip-1-2-3-4.us-east-1.compute.internal          Ready    <none>   3d23h   v1.19.15-eks-9c63c4
ip-1-2-3-5.us-east-1.compute.internal          Ready    <none>   3d23h   v1.19.15-eks-9c63c4
ip-42-42-42-42.us-east-1.compute.internal      Ready    <none>   3d23h   v1.19.15-eks-9c63c4
ip-42-42-42-43.us-east-1.compute.internal      Ready    <none>   3d23h   v1.19.15-eks-9c63c4
```

When for whatever reason (i.e. a node is in `NotReady` status) I want to `ssh` into a node I just want to copypaste the node name and `ssh` into it without having to hand edit it and convert it into an actual IP, or without having to run an additional `kubectl describe <NODE>` or some `jq` parsing to get the node IP.

So this `ssh` wrapper checks the host address and if it matches the EC2 private DNS name pattern it converts it into the actual instance IP before `ssh`ing into it.

## Installation

The most usual method is to simply copypaste the [`ssh()` function](ec2-ssh-wrapper.sh) into your shell RC file: `~/.bashrc` for Bash, `~/.zshrc` for Zsh, etc. Then run `source <RC_file>` or simply open a new shell and your wrapper will be in place.

Run `which ssh` to check whether the installation was correct. Output should show the wrapper instead of `/usr/bin/ssh`.

## Usage

Once installed, just `ssh` normally but using the EC2 private DNS name instead. All passed in parameters (including the user in the form `user@host`) should just work.

```
$ ssh -i ~/.ssh/my_key.pem ec2-user@ip-1-2-3-4.us-east-1.compute.internal
Warning: Permanently added '1.2.3.4' (ED25519) to the list of known hosts.
Last login: Sun Jan 23 03:49:57 2022 from 4.3.2.1

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
6 package(s) needed for security, out of 17 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-1-2-3-4 ~]$
```

Tested in `bash` and `zsh`.