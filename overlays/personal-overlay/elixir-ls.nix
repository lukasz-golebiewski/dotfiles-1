with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "elixir-ls";
  version = "0.6.0";
  # FIXME: this is actually a runtime dependency but I don't know how to
  # specify that?
  buildInputs = [ elixir ];
  src = fetchurl {
    url = "https://github.com/elixir-lsp/elixir-ls/releases/download/v${version}/elixir-ls.zip";
    sha256 = "0wbcpsqjplgd484a11v6bzyv8529z20xq7mmdas261zcch4wz117";
  };

  unpackPhase = ''
    ${unzip}/bin/unzip $src -d ./unpacked
  '';

  installPhase = ''
    mkdir $out
    cp -r unpacked/* $out/
  '';
}

