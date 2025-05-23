{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix, agenix, ... }:
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
            (import "${nixpkgs-unstable}/nixos/modules/services/web-apps/karakeep.nix")
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.manager = import ./home/manager.nix;
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
            (import "${nixpkgs-unstable}/nixos/modules/services/misc/pinchflat.nix")
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.manager = import ./home/manager.nix;
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
        "eren" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./hosts/eren
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.manager = import ./home/manager.nix;
            }
          ];
        };
        "yoda" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./hosts/yoda
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.claes = import ./home/claes.nix;
            }
            stylix.nixosModules.stylix
          ];
        };
      };
    };
}
