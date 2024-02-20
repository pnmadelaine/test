{
  inputs = {
    typhon.url = "github:typhon-ci/typhon";
    nixpkgs.follows = "typhon/nixpkgs";
  };
  outputs = {
    self,
    typhon,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    typhonJobs.${system}.hello = pkgs.hello;
    typhonProject = typhon.lib.github.mkProject {
      owner = "pnmadelaine";
      repo = "test";
      secrets = ./secrets.age;
      typhonUrl = "https://example.com";
    };
  };
}
