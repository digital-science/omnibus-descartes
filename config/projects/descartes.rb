
name "descartes"
maintainer "Gavin Sandie"
homepage "https://github.com/obfuscurity/descartes"

replaces        "descartes"
install_path    "/opt/descartes"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

# creates required build directories
dependency "preparation"

dependency "redis"
dependency "postgresql"
dependency "descartes-cookbooks"
dependency "descartes-ctl"
dependency "descartes"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
