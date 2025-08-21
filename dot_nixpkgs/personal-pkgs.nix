{ pkgs, ...}:

with pkgs; [
    protobuf
    unzip
    minikube
    k9s
    kubernetes-helm
    kubernetes
    llvmPackages_19.libcxxClang
    uv
    glibc
    krew
    kubie
    pyenv
    google-cloud-sdk-gce
    rustup
    k3d
    kind
    docker-compose
    opentofu
    pnpm_10
    k6
    logdy
    kubectx
    kail
    gemini-cli
    deno
    eksctl
]

