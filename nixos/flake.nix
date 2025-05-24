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

      commonModules = [
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
        home-manager.nixosModules.home-manager
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

      mkSystem = { hostname, homeUser, extraModules ? [ ], agenixSecrets ? { } }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit hostname; };
          modules = commonModules ++ [
            ./hosts/common.nix
            ./hosts/${hostname}
            (homeManagerConfig homeUser)
          ] ++ extraModules ++ (if agenixSecrets != { } then agenixConfig agenixSecrets else [ ]);
        };
    in
    {
      nixosConfigurations = {
        "chewbacca" = mkSystem {
          hostname = "chewbacca";
          homeUser = "manager";
          extraModules = [
            (import "${nixpkgs-unstable}/nixos/modules/services/web-apps/karakeep.nix")
          ];
        };

        "luffy" = mkSystem {
          hostname = "luffy";
          homeUser = "manager";
          extraModules = [
            (import "${nixpkgs-unstable}/nixos/modules/services/misc/pinchflat.nix")
          ];
          agenixSecrets = {
            duckdns-token = {
              file = ./secrets/duckdns-token.age;
              mode = "640";
              owner = "traefik";
              group = "traefik";
            };
          };
        };

        "eren" = mkSystem {
          hostname = "eren";
          homeUser = "manager";
        };

        "yoda" = mkSystem {
          hostname = "yoda";
          homeUser = "claes";
          extraModules = [
            stylix.nixosModules.stylix
          ];
        };
      };
    };
}
