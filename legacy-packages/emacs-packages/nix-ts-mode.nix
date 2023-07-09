{
  emacsPackages,
  fetchFromGitHub,
  ...
}:
emacsPackages.trivialBuild {
  pname = "nix-ts-mode";

  src = fetchFromGitHub {
    owner = "remi-gelinas";
    repo = "nix-ts-mode";
    rev = "11d5494f26b837d3ab39d10978524de8c5560658";
    hash = "sha256-4mLjxwkVQZVHEgdUfVNbU5JJm1JxHpDcJ/9LDOh+Xnc=";
  };
}
