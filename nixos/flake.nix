{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, agenix, ... }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
    in
    {
      nixosConfigurations = {
        "chewbacca" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./hosts/chewbacca
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.manager = import ./home.nix;
            }
            agenix.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.${system}.default ];
              age.secrets.duckdns-token.file = ./secrets/duckdns-token.age;
            }
          ];
        };
        "luffy" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./hosts/luffy
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.manager = import ./home.nix;
            }
            agenix.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.${system}.default ];
              age.secrets.duckdns-token = {
                file = ./secrets/duckdns-token.age;
                mode = "640";
                owner = "traefik";
                group = "traefik";
              };
            }
          ];
        };
      };
    };
}
