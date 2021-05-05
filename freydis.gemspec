require File.dirname(__FILE__) + "/lib/freydis/version"

# https://guides.rubygems.org/specification-reference/
Gem::Specification.new do |s|
  s.files = `git ls-files`.split(" ")
  s.files.reject! { |fn| fn.include? "certs" }
  s.name = "freydis"
  s.summary = "Backup and Restore data from encrypted device."
  s.version = Freydis::VERSION
  s.description = <<-EOF
    Freydis is a CLI tool, it will encrypt a device with cryptsetup.
    After that, you can just use option like --save or --restore, these actions will use rsync.
  EOF
  s.email = "szorfein@protonmail.com"
  s.homepage = "https://github.com/szorfein/freydis"
  s.license = "MIT"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/szorfein/freydis/issues",
    "changelog_uri" => "https://github.com/szorfein/freydis/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/szorfein/freydis",
    "wiki_uri" => "https://github.com/szorfein/freydis/wiki",
    "funding_uri" => "https://patreon.com/szorfein",
  }
  s.author = "szorfein"
  s.bindir = "bin"
  s.cert_chain = ["certs/szorfein.pem"]
  s.executables << "freydis"
  s.extra_rdoc_files = ['README.md']
  s.required_ruby_version = ">=2.6"
  s.requirements << 'cryptsetup, v2.3'
  s.requirements << 'rsync, v3.2'
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $@ =~ /gem\z/
end

