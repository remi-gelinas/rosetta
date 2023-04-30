{
  inputs,
  withSystem,
  ...
}: {
  flake.darwinConfigurations.M1 = withSystem "aarch64-darwin" {self', ...}: self.lib.mkDarwinSystem {};
}
