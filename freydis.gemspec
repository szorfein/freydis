require File.dirname(__FILE__) + "/lib/freydis/version"

# https://guides.rubygems.org/specification-reference/
Gem::Specification.new do |s|
  s.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH)
  s.name = "freydis"
  s.summary = "Backup and Restore data from encrypted device."
  s.version = Freydis::VERSION
  s.platform = Gem::Platform::RUBY

  s.description = <<-EOF
    Freydis is a CLI tool to encrypt a disk device, backup and restore easyly. Freydis use `cryptsetup` and `rsync` mainly.
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
  s.executables << "freydis"
  s.extra_rdoc_files = ['README.md']
  s.required_ruby_version = ">=2.6"
  s.requirements << 'cryptsetup, v2.3'
  s.requirements << 'rsync, v3.2'
  s.cert_chain = ['certs/szorfein.pem']
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $@ =~ /gem\z/
end

