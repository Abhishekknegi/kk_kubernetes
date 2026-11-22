To join worker01 and worker02 to your cluster (10.10.0.0/16 VNet, 10.10.1.0/24 subnet, k8s-cp01 at 10.10.1.4), first make sure k8s-cp01 is initialized with kubeadm init and has a CNI plugin installed, then generate the join command on k8s-cp01 and run it on each worker node.

Steps to Initialize k8s-cp01, Generate Join Command, and Join Workers
Commands to Run
1. On k8s-cp01 (10.10.1.4): Initialize control plane (if needed) & configure kubectl
sudo kubeadm init \
  --apiserver-advertise-address=10.10.1.4 \
  --pod-network-cidr=192.168.0.0/16

mkdir -p "$HOME/.kube"
sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"

2. On k8s-cp01: Install CNI (Calico example) & generate the join command
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml

# Generate a fresh join command (valid for 24 hours)
kubeadm token create --print-join-command

(If you already have an unexpired token and only need to print the join command again, run kubeadm token list to check active tokens or run kubeadm token create --print-join-command to issue a fresh one.)

3. On worker01 and worker02: Verify runtime & join the cluster

sudo systemctl is-active crio
sudo systemctl is-enabled kubelet

# Paste the output from `kubeadm token create --print-join-command` on k8s-cp01:
sudo kubeadm join 10.10.1.4:6443 \
  --token <token> \
  --discovery-token-ca-cert-hash sha256:<hash>
4. On k8s-cp01: Verify all 3 nodes joined and are Ready
kubectl get nodes -o wide
