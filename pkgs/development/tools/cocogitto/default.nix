{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv, Security, makeWrapper, libgit2 }:

rustPlatform.buildRustPackage rec {
  pname = "cocogitto";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    sha256 = "sha256-dOiXrHD1ZVhMQNwo7hD/f53Ct5+Lwxq/zbApll5O2qo=";
  };

  cargoHash = "sha256-oO7xqjxlQg0s40WmWNZpEpqdRia4NGGlYbBO8ejW9BE=";

  # Test depend on git configuration that would likely exist in a normal user environment
  # and might be failing to create the test repository it works in.
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libgit2 ] ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installShellCompletion --cmd cog \
      --bash <($out/bin/cog generate-completions bash) \
      --fish <($out/bin/cog generate-completions fish) \
      --zsh  <($out/bin/cog generate-completions zsh)
  '';

  meta = with lib; {
    description = "A set of cli tools for the conventional commit and semver specifications";
    homepage = "https://github.com/oknozor/cocogitto";
    license = licenses.mit;
    maintainers = with maintainers; [ travisdavis-ops ];
  };
}
