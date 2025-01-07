{ pkgs, ...}:

let
  oldPkgs = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/b3a285628a6928f62cdf4d09f4e656f7ecbbcafb.tar.gz";
    })
    { };
  oldKubectl = oldPkgs.kubectl;
in
with pkgs; [
  oldKubectl
  patchelf
  krew
  k6
  kcat
  argocd
  envsubst
  kubeconform
  atuin
  lnav
  nil
  kubectx
  vim
  iterm2
  minikube
  kubie
  htop
  k9s
  grpcurl
  httpie
  eksctl
  aws-iam-authenticator
  grpcui
  rustup
  pnpm
]
