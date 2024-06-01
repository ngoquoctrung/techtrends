# build the image
docker build -t go-helloworld .

# run the image
docker run -d -p 6111:6111 go-helloworld
# Access the application on: http://127.0.0.1:6111/ or http://localhost:6111/ or http://0.0.0.0:6111/
sudo lsof -i -P -n | grep 6111
sudo kill -9 <PID>
# If cannot access the application, run the following command:
curl http://127.0.0.1:6111
curl localhost:6111
curl http://0.0.0.0:6111

# tag the image
docker tag go-helloworld ngoquoctrung/go-helloworld:v1.0.0

# login into DockerHub
docker login

# push the image
docker push ngoquoctrung/go-helloworld:v1.0.0

# Deploy Your First Kubernetes Cluster
# https://learn.udacity.com/paid-courses/cd0308/lessons/e2c69498-1c92-4a41-930e-9ccc62cda59a/concepts/fa47d437-64ee-4228-88a1-1ec45e103210

cd exercises/

# create a vagrant box using the Vagrantfile in the current directory
vagrant up

# Inspect available vagrant boxes 
vagrant status 

# SSH into the vagrant box
# Note: this command uses the .vagrant folder to identify the details of the vagrant box
vagrant ssh

kubectl get no
sudo su
kubectl get no
exit
exit

# Kubeconfig
# https://learn.udacity.com/paid-courses/cd0308/lessons/e2c69498-1c92-4a41-930e-9ccc62cda59a/concepts/f1ccb30e-e70f-4228-a786-a9e9448fd01a

# Install kind
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create a kind cluster
kind create cluster --name demo

sudo su -

# Inspect  the endpoints for the cluster and installed add-ons 
kubectl cluster-info

# List all the nodes in the cluster. 
# To get a more detailed view of the nodes, the `-o wide` flag can be passed
kubectl get nodes [-o wide] 

# Describe a cluster node.
# Typical configuration: node IP, capacity (CPU and memory), a list of running pods on the node, podCIDR, etc.
kubectl describe node {{ NODE NAME }}

# Exercise: Deploy Your First Kubernetes Cluster
# https://learn.udacity.com/paid-courses/cd0308/lessons/e2c69498-1c92-4a41-930e-9ccc62cda59a/concepts/cba180a8-bd52-4740-811a-c8706b0f58d2

vagrant up
vagrant ssh
# Copy the commands from https://k3s.io/ to install the Lightweight Kubernetes in the Vagrant VM
curl -sfL https://get.k3s.io | sh -
# Switch the user to become root
sudo su
k3s kubectl get node
# Run as root
# Get the control plane and add-ons endpoints
kubectl cluster-info
# Get all the nodes in the cluster
kubectl get nodes
# Get extra details about the nodes, including  internal IP
kubectl get nodes -o wide
# Get all the configuration details about the node, including the allocated pod CIDR

# the location of the kubeconfig file: /etc/rancher/k3s/k3s.yaml

# kubectl commands
# to get the control plane and add-ons endpoints
kubectl cluster-info
# to get all the nodes in the cluster
kubectl get nodes - 
# to get extra details about the nodes, including internal IP
kubectl get nodes -o wide - 
# to get all the configuration details about the node, including the allocated pod CIDR
kubectl describe node <node-name> -
# to view the pod CIDR IPs.
kubectl describe node localhost | grep CIDR 

#Kubernetes Resources Part 1
vagrant up
vagrant ssh
# Assuming you are inside the Vagrant VM using the `vagrant ssh` command
# Copy the commands from https://k3s.io/ to install the Lightweight Kubernetes in the Vagrant VM
curl -sfL https://get.k3s.io | sh -
sudo su
k3s kubectl get node

# Assuming you are inside the Vagrant VM
# Replace the image path, as applicable to you, for e.g, pixelpotato/go-helloworld:v1.0.0
kubectl create deploy go-helloworld --image=ngoquoctrung/go-helloworld:v1.0.0
# Get the details
# kubectl get deploy,rs,svc,pods
kubectl get deploy
kubectl get rs
kubectl get po # -> pod/go-helloworld-679655fff6-7s4vp

# Copy the pod name from above and Port forward the pod
kubectl port-forward pod/go-helloworld-7b88cc8f78-sh75j 6111:6111

kubectl delete deploy/go-helloworld
kubectl exec --stdin --tty [pod-name] -- /bin/bash

kubectl edit deploy go-helloworld -o yaml

# Kubernetes Resources Part 3
# https://learn.udacity.com/paid-courses/cd0308/lessons/e2c69498-1c92-4a41-930e-9ccc62cda59a/concepts/a844e271-0edd-4672-8942-e4a8a4892eaa

vagrant up
vagrant ssh
curl -sfL https://get.k3s.io | sh -
sudo su
k3s kubectl get node
kubectl get cm
kubectl create cm test-cm --from-literal=color=blue
kubectl get cm
kubectl describe cm test-cm

kubectl get secrets
kubectl create secret generic test-sec --from-literal=color=red
kubectl get secrets
kubectl describe secrets test-sec
kubectl get secrets test-sec -o yaml
echo "cmVk" | base64 -d

kubectl get ns
kubectl create ns test-udacity
kubectl get ns
kubectl get po
kubectl get po -n test-udacity
kubectl create deploy [...] -n test-udacity

# Solution: Kubernetes Resources

# create the namespace 
# note: label option is not available with `kubectl create`
kubectl create ns demo

# label the namespace
kubectl label ns demo tier=test

# create the nginx-alpine deployment 
kubectl create deploy nginx-alpine --image=nginx:alpine  --replicas=3 --namespace demo

# label the deployment
kubectl label deploy nginx-alpine app=nginx tag=alpine --namespace demo

# expose the nginx-alpine deployment, which will create a service
kubectl expose deployment nginx-alpine --port=8111 --namespace demo

# create a config map
kubectl create configmap nginx-version --from-literal=version=alpine --namespace demo

kubectl get ns

kubectl create ns demo --dry-run=client -o yaml

kubectl create ns demo --dry-run=client -o yaml > namespace.yaml

kubectl create deploy busybox --image=busybox -r=5 -n demo --dry-run=client -o yaml

kubectl create deploy busybox --image=busybox -r=5 -n demo --dry-run=client -o yaml >deploy.yaml

kubectl apply -f deploy.yaml

kubectl get deploy -n demo

kubectl get po -n demo

# Assuming you are in the nd064_course_1/exercises/ directory
cd nd064_course_1/exercises
# Transfer the files from local host to the Vagrant VM
vagrant scp manifests /home/vagrant/

# You should be in the /home/vagrant/ directory of the VM
pwd
# Displays the manifests/ directory
ls
# View the YAML files
cd manifests/
cd ..

# Create the resources
kubectl apply -f manifests/
# Alternatively, you can run these commands oone after another as
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

kubectl get all -n demo

#ArgoCD Walkthrough
vagrant up
vagrant ssh
curl -sfL https://get.k3s.io | sh -
sudo su
k3s kubectl get node
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get po -n argocd
kubectl get svc -n argocd argocd-server -o yaml
kubectl get svc -n argocd argocd-server -o yaml >argocd-nodeport.yaml

#vagrant scp argocd-server-nodeport.yaml /home/vagrant/
vagrant plugin install vagrant-scp
vagrant upload argocd-server-nodeport.yaml /home/vagrant/
kubectl apply -f argocd-server-nodeport.yaml

kubectl get svc -n argocd

curl http://192.168.56.4:30008/
sudo netstat -tulnp | grep :30008
