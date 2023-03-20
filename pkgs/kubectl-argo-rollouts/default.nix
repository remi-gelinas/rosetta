{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-argo-rollouts";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${version}";
    sha256 = "sha256-MpiKdPjQRF1LzNxBvPucoeRkDfboJdStfQ6X+d2jiwk=";
  };

  vendorSha256 = "sha256-ZIFZCMyhpfKK/Irq2/MvkXuXX1jExDaSK/nXZgzCZgU=";
}