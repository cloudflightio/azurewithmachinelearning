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
            azure-cli
            azure-functions-core-tools
            python311
            python311Packages.virtualenv
          ];
		  LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libGL}/lib/:${pkgs.glib.out}/lib";
		  DONT_PROMPT_WSL_INSTALL="true";

          shellHook = ''
             extensions="ms-python.python ms-azuretools.vscode-azurefunctions humao.rest-client"
             if ! command -v code &> /dev/null; then
                 echo "VSCode could not be found. Please install VSCode and the missing plugins '$extensions' manually."
             else
                 echo "VSCode is installed. Checking for required extensions..."
                 for extension in $extensions; do
                     if ! code --list-extensions | grep -q "$extension"; then
                         code --install-extension "$extension"
                     fi
                 done
             fi

             echo "Creating directory structure..."
             mkdir -p ./HttpTrigger/models

             echo "Navigating to HttpTrigger directory..."
             pushd ./HttpTrigger

             if [ ! -d ".venv" ]; then
                 echo "Creating virtual environment..."
                 python3.11 -m venv .venv
             fi
             source .venv/bin/activate

             echo "Upgrading pip..."
             pip3 install --upgrade pip

             echo "Installing required Python packages..."
             pip3 install azure-functions opencv-python onnxruntime numpy

             echo "Setting PYTHONPATH..."
             export PYTHONPATH=$(pwd)/.venv/lib/python3.11/site-packages

             echo "Navigating to models directory..."
             pushd ./models

             echo "Downloading model files..."
             curl -L https://media.githubusercontent.com/media/onnx/models/refs/heads/main/validated/vision/body_analysis/ultraface/models/version-RFB-640.onnx?download=true -O
             curl -L https://media.githubusercontent.com/media/onnx/models/refs/heads/main/validated/vision/body_analysis/age_gender/models/vgg_ilsvrc_16_age_imdb_wiki.onnx?download=true -O
             curl -L https://media.githubusercontent.com/media/onnx/models/refs/heads/main/validated/vision/body_analysis/emotion_ferplus/model/emotion-ferplus-8.onnx?download=true -O

             echo "Returning to previous directory..."
             popd
             popd

             if command -v code &> /dev/null; then
                 echo "Opening VSCode..."
                 code .
             fi
          '';
        };
      });
    };
}
