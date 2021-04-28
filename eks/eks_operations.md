# DIL Deployment via Terraform

## How to execute the modules

Execute following commands to deploy the resources

```
terraform init
terraform validate
terraform plan
terraform apply
```

## How to setup AWS CLI

### Install AWS CLI
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

You need to configure 2 AWS profiles to work with MFA.

### First create  default AWS profile
```
aws configure
```
Specify the access ID , Secret Key and the default region which is "eu-central-1"

### Next create another profile to use the MFA session credentials

```
aws configure --profile <any name> #ie: dt_deployment
```
Promp will ask for your accesskey,secret ID,default region and the output you prefer. For the output you can specify "json"
Region is "eu-central-1"


### Generate session token

Following command will give you the access ID,Secret Key and the Session token. During the execution you need to use your MFA device auto genrated code as <token>. If you want to keep the session valid for 1 days then use the duration 86400 instead of
3600

```
aws sts get-session-token --duration 3600 --serial-number arn:aws:iam::<aws account ID>:mfa/<username> --token-code <token>
```

After generating the credentials, use the access ID, secret key and aws session token to replace the secondary profile you
created.

ie:
aws_access_key_id = "access id"
aws_secret_access_key = "secret access key"
aws_session_token = "token


## How to authenticate with EKS using Kubectl

After you updated your profile with generated credentials, you will be able to access EKS cluster from AWS CLI
```
aws eks --region eu-central-1 update-kubeconfig --name dil-eu-central-1-eks-dev <profile name>
```

## How to check kubconfig file

```
kubectl edit -n kube-system configmap/aws-auth
```

# Kubernetes resource deployment
## Configure RBAC
Necessary manigest files are available under kubernetes/user-rbac
execute the following command in alb directory
```
kubectl create -f .
```

## Deploy ALB ingress controller
Necessary manigest files are available under kubernetes/alb
execute the following command in alb directory
```
kubectl create -f .
```

## How to view ALB ingress logs
```
kubectl logs -f $(kubectl get pod -n kube-system | egrep -o 'alb-ingress-controller-[A-Za-z0-9-]+') -n kube-system
```
