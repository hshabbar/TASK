
The repository structure for the given task
```
.
└── TASK
    └── mytask
        ├── eksctl
        │   └── cluster-conf.yaml
        ├── kubernetes_manifests
        │   ├── canary
        │   │   ├── canary-deployment.yaml
        │   │   ├── canary-service.yaml
        │   │   ├── primary-canary-ingress.yaml
        │   │   ├── primary-deployment.yaml
        │   │   └── primary-service.yaml
        │   └── nginx_web_server
        │       ├── loadbalancer_service.yaml
        │       ├── namespace.yaml
        │       └── nginx_deployment.yaml
        └── terraform
            ├── with_modules
            │   ├── main.tf
            │   ├── modules
            │   │   ├── eks
            │   │   │   ├── eks.tf
            │   │   │   ├── input.tf
            │   │   │   └── output.tf
            │   │   └── vpc_and_subnets
            │   │       ├── input.tf
            │   │       ├── output.tf
            │   │       └── vpc-and-subnets.tf
            │   └── provider.tf
            └── without_modules
                ├── eks.tf
                ├── input.tf
                ├── output.tf
                ├── provider.tf
                ├── terraform.tfvars
                └── vpc-and-subnets.tf
```
**Terraform**
1. First I used terraform to create a VPC with public and private subnets. For my task, I have used the 'without_modules' approach but I have also tested and uploaded a 'with_modules' approach.

The `vpc-and-subnets.tf` file will create a VPC with public and private subnets. I have also included the `terraform.tfvars` file along with `input.tf` and `output.tf` files for this project and the provider is AWS. 

`mytask/terraform/without_modules/vpc-and-subnets.tf`
```
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "VPC for task"
  }
}


resource "aws_subnet" "my_public_subnet_one" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_one_cidr
  availability_zone = var.public_subnet_one_availability_zone
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Public subnet one for the task"
  }
}


resource "aws_subnet" "my_public_subnet_two" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_two_cidr
  availability_zone = var.public_subnet_two_availability_zone
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Public subnet two for the task"
  }
}


resource "aws_subnet" "my_private_subnet_one" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_one_cidr
  availability_zone = var.private_subnet_one_availability_zone
  tags = {
    Name = "Private subnet one for the task"
  }
}


resource "aws_subnet" "my_private_subnet_two" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_two_cidr
  availability_zone = var.private_subnet_two_availability_zone
  tags = {
    Name = "Private subnet two for the task"
  }
}


resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Internet Gateway for public subnets's route table"
  }
}


resource "aws_eip" "my_elastic_ip_for_nat_one" {
}


resource "aws_eip" "my_elastic_ip_for_nat_two" {
}


resource "aws_nat_gateway" "my_nat_gateway_one" {
  allocation_id = aws_eip.my_elastic_ip_for_nat_one.id
  subnet_id     = aws_subnet.my_public_subnet_one.id
  tags = {
    Name = "Nat gateway for private subnet's route table one"
  }
  depends_on = [aws_internet_gateway.my_internet_gateway]
}


resource "aws_nat_gateway" "my_nat_gateway_two" {
  allocation_id = aws_eip.my_elastic_ip_for_nat_two.id
  subnet_id     = aws_subnet.my_public_subnet_two.id
  tags = { 
    Name = "Nat gateway for private subnet's route table two"
  }
  depends_on = [aws_internet_gateway.my_internet_gateway]
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }
  tags = {
    Name = "Route table for public subnet"
  }
}


resource "aws_route_table" "private_route_table_one" {
  vpc_id = aws_vpc.my_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway_one.id
  }
  tags = {
    Name = "Route table for private subnet one"
  }
}


resource "aws_route_table" "private_route_table_two" {
  vpc_id = aws_vpc.my_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway_two.id
  }
  tags = {
    Name = "Route table for private subnet two"
  }
}


resource "aws_route_table_association" "public_route_table_association_one" {
  subnet_id      = aws_subnet.my_public_subnet_one.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "public_route_table_association_two" {
  subnet_id      = aws_subnet.my_public_subnet_two.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "private_route_table_association_one" {
  subnet_id      = aws_subnet.my_private_subnet_one.id
  route_table_id = aws_route_table.private_route_table_one.id
}


resource "aws_route_table_association" "private_route_table_association_two" {
  subnet_id      = aws_subnet.my_private_subnet_two.id
  route_table_id = aws_route_table.private_route_table_two.id
}
```

Used the below commands during the creation of the netwokring infrastructure:
```
terraform init
terraform plan
terraform apply
```
**Eksctl**

2. The terraform project created the networking infrastructure and I used the above created VPC and subnets in the below `ClusterConfig` file to be used by eksctl to create an EKS cluster.

`mytask/eksctl/cluster-conf.yaml`
```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: eks-task
  region: ap-south-1
  version: "1.28"

vpc:
  clusterEndpoints:
    publicAccess:  true
    privateAccess: false
  
  subnets:
    public:
      ap-south-1a: { id: subnet-09e6a6f24a14219a5 }
      ap-south-1b: { id: subnet-0ecc1ae8b8060e097 }
    private:
      ap-south-1a: { id: subnet-0868d40b89974212f }
      ap-south-1b: { id: subnet-0ee06f2196521d124 }

nodeGroups:
  - name: nodegroup-1
    instanceType: t3.medium
    desiredCapacity: 1
    privateNetworking: true
    volumeSize: 20
#   ssh:
#     allow: true
#     publicKeyPath: ~/.config/key.pub
    iam:
      attachPolicyARNs:
        - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
        - arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
        - arn:aws:iam::aws:policy/AmazonSSMFullAccess
#        - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy

managedNodeGroups:
  - name: managed-nodegroup-1
    minSize: 0
    maxSize: 5
    desiredCapacity: 1
    volumeSize: 20
#   ssh:
#     allow: true
#     publicKeyPath: ~/.config/key.pub
    instanceType: t3.medium
    iam:
      attachPolicyARNs:
        - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
        - arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
        - arn:aws:iam::aws:policy/AmazonSSMFullAccess

iam:
  withOIDC: true

addons:
- name: vpc-cni
  attachPolicyARNs:
    - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
- name: coredns
  version: latest
- name: kube-proxy
  version: latest

cloudWatch:
  clusterLogging:
    enableTypes: ["audit", "authenticator", "controllerManager", "api", "scheduler"]
```

Used the below command to create the cluster
```
eksctl create cluster -f cluster-conf.yaml
```

 **Kubernetes Resources:**
 
3. Created kubernetes NGINX webserver deployment and service.

`NAMESPACE: mytask/kubernetes_manifests/nginx_web_server/namespace.yaml`
```
apiVersion: v1
kind: Namespace
metadata:
  name: nginx
```

`DEPLOYMENT: mytask/kubernetes_manifests/nginx_web_server/nginx_deployment.yaml`
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-web-server
  namespace: nginx
  labels:
    app: nginx-web-server-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-web-server-app
  template:
    metadata:
      labels:
        app: nginx-web-server-app
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/arch
                operator: In
                values:
                - amd64
                - arm64
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - name: http
          containerPort: 80
        imagePullPolicy: IfNotPresent
      nodeSelector:
        kubernetes.io/os: linux
```


`SERVICE: mytask/kubernetes_manifests/nginx_web_server/loadbalancer_service.yaml`
```
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-loadbalancer
  namespace: nginx
spec:
  type: LoadBalancer
  selector:
    app: nginx-web-server-app
  ports:
    - protocol: TCP
      port: 80
```


4. NGINX webserver resources:
```
$ kubectl get pods -n nginx
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
nginx         nginx-web-server-5fbf89b59-4v972   1/1     Running   0          57s
nginx         nginx-web-server-5fbf89b59-f2dw8   1/1     Running   0          57s


$ kubectl get svc -n nginx
NAMESPACE     NAME                         TYPE           CLUSTER-IP      EXTERNAL-IP                                                                PORT(S)                  AGE
nginx         nginx-service-loadbalancer   LoadBalancer   10.100.156.97   a0ee67e5fa233486d800596664dbf476-1718245683.ap-south-1.elb.amazonaws.com   80:31033/TCP             7s
```

5. **For the purpose of implementing the Canary approach, I had installed the AWS loadbalancer controller**

Followed the AWS documentaion to install AWS loadbalancer controller: https://docs.aws.amazon.com/eks/latest/userguide/lbc-manifest.html

6. Used the below kubernetes manifests to deploy the kubernetes resources for the `primary` deployment and service:

`PRIMARY DEPLOYMENT: mytask/kubernetes_manifests/canary/primary-deployment.yaml`
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: primary
  name: primary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: primary
  template:
    metadata:
      labels:
        app: primary
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
```

`PRIMARY SERVICE: mytask/kubernetes_manifests/canary/primary-service.yaml`

```
apiVersion: v1
kind: Service
metadata:
  labels:
    app: primary
  name: primary-service
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: primary
```

6. Used the below kubernetes manifests to deploy the kubernetes resources for the `canary` deployment and service:

`CANARY DEPLOYMENT: mytask/kubernetes_manifests/canary/canary-deployment.yaml`

```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: canary
  name: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: canary
  template:
    metadata:
      labels:
        app: canary
    spec:
      containers:
      - image: bhargavshah86/kube-test:v0.1 #used a publicly available app image here
#       command: ["/bin/sh", "-c", "sleep 3600"]
        name: webserver
        ports:
        - containerPort: 80
```

`CANARY SERVICE: mytask/kubernetes_manifests/canary/canary-service.yaml`
```
apiVersion: v1
kind: Service
metadata:
  labels:
    app: canary
  name: canary-service
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: canary
```

7. Used the below `ingress` manifests to create an Application Laodbalancer that splits the traffic in the ration 90:10 between the `primary` and the `canary` backends:

`INGRESS: mytask/kubernetes_manifests/canary/primary-canary-ingress.yaml`
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: primary-canary-ingress
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: primary-canary-lb
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/actions.weighted-routing: |
      {
          "type": "forward",
          "forwardConfig": {
              "targetGroups": [
                  {
                      "serviceName": "primary-service",
                      "servicePort": 80,
                      "weight": 90
                  },
                  {
                      "serviceName": "canary-service",
                      "servicePort": 80,
                      "weight": 10
                  }
              ],
              "targetGroupStickinessConfig": {
                  "enabled": false
              }
          }
      }
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
          - backend:
              service:
                name: weighted-routing
                port: 
                  name: use-annotation
            pathType: ImplementationSpecific
```

8. PRIMARY and CANARY reosurces output:

```
$ kubectl get pods
NAME                       READY   STATUS    RESTARTS     AGE
canary-7b6445db5d-fpcz6    1/1     Running   0          23s
primary-5c9df86fbd-n8sr7   1/1     Running   0          64m


$ kubectl get svc -o wide
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE     SELECTOR
canary-service    ClusterIP   10.100.196.113   <none>        80/TCP    58m     app=canary
kubernetes        ClusterIP   10.100.0.1       <none>        443/TCP   6h23m   <none>
primary-service   ClusterIP   10.100.146.201   <none>        80/TCP    60m     app=primary


$ kubectl get endpoints
NAME              ENDPOINTS                          AGE
canary-service    172.31.43.44:3000                  58m
kubernetes        172.31.47.70:443,172.31.65.8:443   6h24m
primary-service   172.31.37.190:80                   60m


$ kubectl get ingress
NAME                     CLASS   HOSTS   ADDRESS                                                    PORTS   AGE
primary-canary-ingress   alb     *       primary-canary-lb-847039720.ap-south-1.elb.amazonaws.com   80      36m
```

**Clean Up**

8. Deleted the resources using the following commands

```
kubectl delete ingress primary-canary-ingress
kubectl delete service canary-service
kubectl delete service primary-service
kubectl delete deploy canary
kubectl delete deploy primary

kubectl delete svc nginx-service-loadbalancer -n nginx
kubectl delete deploy nginx-web-server -n nginx
kubectl delete namespace nginx

eksctl delete cluster -f cluster-config.yaml

terraform destroy
```
