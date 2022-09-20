# frozen_string_literal: true

require File.dirname(__FILE__) + "/lib/freydis/version"

# https://guides.rubygems.org/specification-reference/
Gem::Specification.new do |s|
  s.name = 'freydis'
  s.summary = 'Backup and Restore data from encrypted device.'
  s.version = Freydis::VERSION
  s.platform = Gem::Platform::RUBY

  s.description = <<~DESC
    Freydis is a CLI tool to encrypt a disk device, backup and restore easyly. Freydis use `cryptsetup` and `rsync` mainly.
  DESC

  s.email = 'szorfein@protonmail.com'
  s.homepage = 'https://github.com/szorfein/freydis'
  s.license = 'MIT'
  s.author = 'szorfein'

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/szorfein/freydis/issues',
    'changelog_uri' => 'https://github.com/szorfein/freydis/blob/main/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/szorfein/freydis',
    'funding_uri' => 'https://patreon.com/szorfein',
  }

  s.files = Dir.glob('{lib,bin}/**/*', File::FNM_DOTMATCH).reject { |f| File.directory?(f) }

  # Include the CHANGELOG.md, LICENSE.md, README.md manually
  s.files += %w[CHANGELOG.md LICENSE README.md]
  s.files += %w[freydis.gemspec]

  s.bindir = 'bin'
  s.executables << 'freydis'
  s.require_paths = ['lib']

  s.cert_chain = ['certs/szorfein.pem']
  s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')

  s.required_ruby_version = '>= 2.6'
  s.requirements << 'cryptsetup'
  s.requirements << 'rsync'
end

