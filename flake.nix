{
	description = "AutoEq Application";

	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	};

	outputs = inputs@{flake-parts, ... }: let
			project_name = "Name";
		in flake-parts.lib.mkFlake {inherit inputs;} {
			imports = [
				inputs.flake-parts.flakeModules.easyOverlay
			];
			systems = ["x86_64-linux"];
			perSystem = {config, pkgs, system, ... }: rec {
				overlayAttrs = { inherit (packages) autoeq; };
				packages = rec {
					autoeq = pkgs.python311.pkgs.buildPythonApplication rec {
						pname = "autoeq";
						version = "4.1.2";
						src = pkgs.fetchFromGitHub {
							owner = "jaakkopasanen";
							repo = "AutoEq";
							tag = version;
							hash = "sha256-bNqgxDQUIj4hDCIZzASFtEu3L64EYBCcBJYuWApBZ4c=";
						};
						patches = [
							./autoeq.patch
						];
						
						pyproject = true;
						# build-system = ["setuptools"];
						propagatedBuildInputs = with pkgs; [
							python311Packages.pillow
							python311Packages.hatchling
							python311Packages.matplotlib
							python311Packages.numpy
							python311Packages.scipy
							python311Packages.tabulate
							python311Packages.pyyaml
							python311Packages.soundfile
							python311Packages.tqdm
						];
					};
					default = autoeq;
				};
			};
			flake = {};
		};
}
