{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" ];
    in
    {
      devShells = forAllSystems (system: {
        default = with (import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        }); mkShell {
          buildInputs = [
            gcc-unwrapped
		    glib
	        vscode
            azure-cli
            azure-functions-core-tools
            python311
            python311Packages.virtualenv
            git-lfs
          ];
		  LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libGL}/lib/:${pkgs.glib.out}/lib";
		  DONT_PROMPT_WSL_INSTALL="true";
          shellHook = ''
          # Define VSCode extensions to install
          extensions="ms-python.python ms-azuretools.vscode-azurefunctions humao.rest-client"

          # Install VSCode extensions
          for extension in $extensions; do
            if ! code --list-extensions | grep -q "$extension"; then
              code --install-extension "$extension"
            fi
          done

          # Create and activate a virtual environment
          mkdir ./HttpTrigger
          pushd ./HttpTrigger
          if [ ! -d ".venv" ]; then
            python3.11 -m venv .venv
          fi
          source .venv/bin/activate

          # Upgrade pip to ensure the latest packages can be installed
          pip3 install --upgrade pip

          # Install Python dependencies
          pip3 install azure-functions opencv-python onnxruntime numpy

          export PYTHONPATH=$(pwd)/.venv/lib/python3.11/site-packages

          # Open
          code ..
        '';
        };
      });
    };
}
