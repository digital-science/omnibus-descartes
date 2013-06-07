name "descartes"
version "master"


dependency "libxslt"
dependency "libxml2"
dependency "libiconv"
dependency "ruby"
dependency "rubygems"
dependency "bundler"
dependency "rsync"

source :git => "git://github.com/obfuscurity/descartes.git"

relative_path "descartes"

build do
  bundle "install --path=#{install_dir}/embedded/service/gem"
  command "mkdir -p #{install_dir}/embedded/service/descartes"
  command "#{install_dir}/embedded/bin/rsync -a --delete  ./ #{install_dir}/embedded/service/descartes/"
end
