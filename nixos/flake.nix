{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      disko,
      home-manager,
      agenix,
      ...
    }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      };

      commonModules = [
        (
          { config, pkgs, ... }:
          {
            nixpkgs.overlays = [ overlay-unstable ];
          }
        )
        home-manager.nixosModules.home-manager
        (import "${nixpkgs-unstable}/nixos/modules/services/monitoring/beszel-agent.nix")
        (import "${nixpkgs-unstable}/nixos/modules/services/monitoring/beszel-hub.nix")
      ];

      homeManagerConfig = user: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import ./home/${user}.nix;
      };

      agenixConfig = secrets: [
        agenix.nixosModules.default
        {
          environment.systemPackages = [ agenix.packages.${system}.default ];
          age.secrets = secrets;
        }
      ];

      mkSystem =
        {
          hostname,
          homeUser,
          extraModules ? [ ],
          agenixSecrets ? { },
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit hostname; };
          modules =
            commonModules
            ++ [
              ./hosts/common.nix
              ./hosts/${hostname}
              (homeManagerConfig homeUser)
            ]
            ++ extraModules
            ++ (if agenixSecrets != { } then agenixConfig agenixSecrets else [ ]);
        };
    in
    {
      nixosConfigurations = {
        "naruto" = mkSystem {
          hostname = "naruto";
          homeUser = "manager";
          agenixSecrets = {
            user-manager-password = {
              file = ./secrets/user-manager-password.age;
            };
          };
          extraModules = [
            disko.nixosModules.disko
          ];
        };

        "luffy" = mkSystem {
          hostname = "luffy";
          homeUser = "manager";
          agenixSecrets = {
            duckdns-token = {
              file = ./secrets/duckdns-token.age;
              mode = "640";
              owner = "traefik";
              group = "traefik";
            };
            user-manager-password = {
              file = ./secrets/user-manager-password.age;
            };
          };
          extraModules = [
            {
              disabledModules = [ "services/misc/duckdns.nix" ];
            }
          ];
        };

        "eren" = mkSystem {
          hostname = "eren";
          homeUser = "manager";
          agenixSecrets = {
            user-manager-password = {
              file = ./secrets/user-manager-password.age;
            };
          };
        };

        "yoda" = mkSystem {
          hostname = "yoda";
          homeUser = "claes";
        };

        "ichigo" = mkSystem {
          hostname = "ichigo";
          homeUser = "claes";
          agenixSecrets = {
            user-claes-password = {
              file = ./secrets/user-claes-password.age;
            };
          };
        };
      };
    };
}
