{inputs}: {
  registry = {
    nixpkgs.flake = inputs.nixpkgs-unstable;
    nixpkgs-master.flake = inputs.nixpkgs-master;
  };

  nixPath = [
    "nixpkgs=flake:nixpkgs"
    "nixpkgs-master=flake:nixpkgs-master"
  ];
}
