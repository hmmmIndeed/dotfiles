{
	description = "config flake";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
		nixpkgs-quartus.url = "github:nixos/nixpkgs/nixos-22.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		waveforms.url = "github:liff/waveforms-flake";

		home-manager = {
		  url = "github:nix-community/home-manager/release-23.11";
		  # The `follows` keyword in inputs is used for inheritance.
		  # Here, `inputs.nixpkgs` of home-manager is kept consistent with
		  # the `inputs.nixpkgs` of the current flake,
		  # to avoid problems caused by different versions of nixpkgs.
		  inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = {self, nixpkgs, home-manager, ...}@inputs: {
		overlays = import .overlays.nix {inherit inputs;};

		nixosConfigurations.eva = nixpkgs.lib.nixosSystem {
			specialArgs = {inherit inputs outputs;};
			modules = [

				./configuration.nix
				home-manager.nixosModules.home-manager
				{
				  home-manager.useGlobalPkgs = true;
				  home-manager.useUserPackages = true;


				  # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
				}
				waveforms.nixosModule
				({users.users.asulk.extraGroups = [ "plugdev"]; })
			];
		};
	};
}
