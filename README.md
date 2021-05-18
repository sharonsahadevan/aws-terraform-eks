# terraform-aws-eks

EKS cluster with manged nodes can be deployed to a custom VPC, which is deployed in a difference workspace. Prebuilt EKS and VPC modules have been used
to avoid reinventing the wheels.

**[EKS module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)**
**[VPC module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)**

## Assumptions

* You want to create an EKS cluster and an autoscaling group of workers for the cluster.
* You want these resources to exist within security groups that allow communication and coordination. These can be user provided or created within the module.
* You've created a Virtual Private Cloud (VPC) and subnets where you intend to put the EKS resources. The VPC satisfies [EKS requirements](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html).

## Important note

The `cluster_version` is the required variable. Kubernetes is evolving a lot, and each major version includes new features, fixes, or changes.

**Always check [Kubernetes Release Notes](https://kubernetes.io/docs/setup/release/notes/) before updating the major version.**

You also need to ensure your applications and add ons are updated, or workloads could fail after the upgrade is complete. For action, you may need to take before upgrading, see the steps in the [EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html).

An example of harming update was the removal of several commonly used, but deprecated  APIs, in Kubernetes 1.16. More information on the API removals, see the [Kubernetes blog post](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/).

By default, this module manages the `aws-auth` configmap for you (`manage_aws_auth=true`). To avoid the following [issue](https://github.com/aws/containers-roadmap/issues/654) where the EKS creation is `ACTIVE` but not ready, we implemented a retry logic with an `local-exec` provisioner and `wget` (by default) with failover to `curl`.

**If you want to manage your `aws-auth` configmap, ensure you have `wget` (or `curl`) and `/bin/sh` installed where you're running Terraform or set `wait_for_cluster_cmd` and `wait_for_cluster_interpreter` to match your needs.**

For windows users, please read the following [doc](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md#deploying-from-windows-binsh-file-does-not-exist).




## Other documentation

* [Autoscaling](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md): How to enable worker node autoscaling.
* [Enable Docker Bridge Network](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/enable-docker-bridge-network.md): How to enable the docker bridge network when using the EKS-optimized AMI, which disables it by default.
* [Spot instances](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/spot-instances.md): How to use spot instances with this module.
* [IAM Permissions](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md): Minimum IAM permissions needed to setup EKS Cluster.
* [FAQ](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md): Frequently Asked Questions
