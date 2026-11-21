To join worker01 and worker02 to your cluster (10.10.0.0/16 VNet, 10.10.1.0/24 subnet, k8s-cp01 at 10.10.1.4), first make sure k8s-cp01 is initialized with kubeadm init and has a CNI plugin installed, then generate the join command on k8s-cp01 and run it on each worker node.Steps to Initialize k8s-cp01, Generate Join Command, and Join Workers1.Initialize the Kubernetes control plane:On k8s-cp01 (if not initialized yet).Run kubeadm init with a pod network CIDR that fits your 10.10.0.0/16 VNet without IP overlap (for example 192.168.0.0/16 for Calico or 10.244.0.0/16 for Flannel), and copy admin.conf so kubectl works for azureadmin (and root).Verification: kubeadm init completes and kubectl get nodes shows k8s-cp01 (currently NotReady until a CNI is installed).2.Install a Container Network Interface (CNI) plugin:On k8s-cp01.Deploy a CNI plugin such as Calico or Flannel on k8s-cp01 so CoreDNS and node networking become ready.Verification: kubectl get pods -n kube-system shows coredns pods running or ready once the CNI pods start.3.Generate (or print) the kubeadm join command:On k8s-cp01.Run kubeadm token create --print-join-command on k8s-cp01 to output a fresh 24-hour bootstrap token and --discovery-token-ca-cert-hash.Verification: The command prints a full line starting with kubeadm join 10.10.1.4:6443 --token ... --discovery-token-ca-cert-hash sha256:....4.Confirm prerequisites and run kubeadm join as root:On worker01 and worker02.Ensure crio is active and kubelet is enabled on both worker nodes, then run the exact kubeadm join command from k8s-cp01 with sudo or as root.Verification: kubeadm join finishes with This node has joined the cluster:, and kubectl get nodes -o wide from k8s-cp01 lists k8s-cp01, worker01, and worker02 as Ready.Commands to Run1. On k8s-cp01 (10.10.1.4): Initialize control plane (if needed) & configure kubectlBashsudo kubeadm init \
  --apiserver-advertise-address=10.10.1.4 \
  --pod-network-cidr=192.168.0.0/16

mkdir -p "$HOME/.kube"
sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"
2. On k8s-cp01: Install CNI (Calico example) & generate the join commandBashkubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml

# Generate a fresh join command (valid for 24 hours)
kubeadm token create --print-join-command
(If you already have an unexpired token and only need to print the join command again, run kubeadm token list to check active tokens or run kubeadm token create --print-join-command to issue a fresh one.)3. On worker01 and worker02: Verify runtime & join the clusterBashsudo systemctl is-active crio
sudo systemctl is-enabled kubelet

# Paste the output from `kubeadm token create --print-join-command` on k8s-cp01:
sudo kubeadm join 10.10.1.4:6443 \
  --token <token> \
  --discovery-token-ca-cert-hash sha256:<hash>
4. On k8s-cp01: Verify all 3 nodes joined and are ReadyBashkubectl get nodes -o wide
