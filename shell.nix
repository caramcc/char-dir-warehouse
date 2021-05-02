with (import (fetchTarball {
  name = "nixpkgs-2021-03-20";
  url = "https://github.com/nixos/nixpkgs/archive/35e8b7c68fef89ce80fa0b6db009beb7cd71c24e.tar.gz";
  # obtained by running nix-prefetch-url --name <name> --unpack <url>
  sha256 = "1ainklmsrz3442czxw53ljbz4k2ambqwl13x31mx0pyidq15xi0z";
}) {});

let

  old_pkgs = import (builtins.fetchGit {
      name = "bundler_1_17";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "fcc8660d359d2c582b0b148739a72cec476cfef5";
  }) {};

  old_ruby = import (builtins.fetchTarball {
      name = "old-ruby-2019-09-02";
      url = "https://github.com/NixOS/nixpkgs/archive/84f318e323989435d5dd54b4038b0af728f20c85.tar.gz";
      sha256 = "08s1lbp0hy5cyga67bwcylvqp0y9s8wb23pxzrc6ir300r6nnng0";
  }) {};

  bundler_1_17 = old_pkgs.bundler;
  ruby_2_3 = old_ruby.ruby_2_3;

  requiredNixVersion = "2.3";

in

if lib.versionOlder builtins.nixVersion requiredNixVersion == true then
  abort "This project requires Nix >= ${requiredNixVersion}, please run 'nix-channel --update && nix-env -i nix'."
else


  mkShell {
    buildInputs = [
      stdenv
      git
      cacert
      shared-mime-info

      # Ruby and Rails dependencies
      ruby_2_3
      bundler_1_17
      openssl
      clang
      libxml2
      libxslt
      libiconv

      # javascript
      nodejs
      yarn

      # infrastructure
      overmind
      postgresql_11
      redis
    ];

    # todo lo0
    HOST = "127.0.0.1";

    RAILS_ENV = "development";

    BUNDLE_BUILD__NOKOGIRI = ''
      --with-xml2-lib=${pkgs.libxml2}
      --with-xslt-lib=${pkgs.libxslt}
      --with-iconv-lib=${pkgs.libiconv}
    '';
    BUNDLE_BUILD__SASSC = ''
      --disable-lto
    '';
    BUNDLE_PATH = "vendor/bundle";
    BUNDLE_JOBS = "8";

    FREEDESKTOP_MIME_TYPES_PATH = shared-mime-info + "/share/mime/packages/freedesktop.org.xml";
  }
