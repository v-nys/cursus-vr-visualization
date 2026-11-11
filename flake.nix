{
  description = "Here to Slay Flask application and Playwright tests";

  inputs = {
    nixpkgs.follows = "python-dev-env/nixpkgs";
    python-dev-env.url = "git+ssh://git@codeberg.org/v-nys/python-development-env.git";
  };

  outputs =
    {
      self,
      nixpkgs,
      python-dev-env,
    }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      devShells = {
        "x86_64-linux".default = python-dev-env.lib.mkDevShellWithExtras ({
          packagesIncludingPython = [
            pkgs.python3
            pkgs.python3Packages.flask
            pkgs.python3Packages.jinja2
            pkgs.nodejs
            pkgs.playwright-test
            pkgs.playwright-driver.browsers
            pkgs.fontconfig
            pkgs.dejavu_fonts
          ];
          preShellHook = ''
            export PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}"
            export FONTCONFIG_FILE="${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
            export FONTCONFIG_PATH="${pkgs.fontconfig.out}/etc/fonts"
            export PYTHONPATH="$PWD:$PYTHONPATH"
          '';
          zellijLayout = ./zellij-layout.kdl;
        });
      };

      apps = {
      };
    };
}
