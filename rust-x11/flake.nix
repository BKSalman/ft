{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {nixpkgs,  rust-overlay, ...}:
      let 
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; overlays = [ rust-overlay.overlays.default ]; };
      in
    with pkgs; {
      devShells.${system}.default = mkShell {
          packages = [
            xmodmap
            gdb
          ];
          
          nativeBuildInputs = [
          ];
          
          buildInputs = [
           (rust-bin.stable.latest.default.override {
              extensions = [ "rust-src" "rust-analyzer" ];
            })
            # auto reload server on save
            # cargo watch -x run
            cargo-watch
            pkg-config
            libX11
            libXft
            libXrandr
            libXinerama
          ];

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ pkgs.libX11 pkgs.libXcursor pkgs.libXrandr pkgs.libXi pkgs.libXft pkgs.fontconfig pkgs.freetype ]}";
        };

      formatter.x86_64-linux = legacyPackages.${system}.nixpkgs-fmt;
    };
}


