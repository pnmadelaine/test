{
  inputs = {
    typhon.url = "github:typhon-ci/typhon/pnm/clearenv";
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
    typhonJobs.${system} = {
      hello = pkgs.writeTextDir "index.html" "Hello world!";
      failure = pkgs.stdenv.mkDerivation {name = "failure";};
    };
    #typhonProject = typhon.lib.github.mkProject {
    #  owner = "pnmadelaine";
    #  repo = "test";
    #  secrets = pkgs.writeText "secrets" "";
    #  typhonUrl = "https://example.com";
    #};
    typhonProject = typhon.lib.builders.mkProject {
      actions.begin = typhon.lib.builders.mkActionScript {
        mkPath = system: let
          pkgs = import nixpkgs {inherit system;};
        in [pkgs.nix pkgs.jq];
        mkScript = system: ''
          url=$(cat | jq '.input.url')
          rev=$(nix --extra-experimental-feature nix-command eval --json --expr "builtins.parseFlakeRef \"$url\"" | jq -r '.rev')
          echo "$rev" >&2
        '';
      };
    };
  };
}
