# frozen_string_literal: true

# https://github.com/seattlerb/minitest#running-your-tests-
require 'rake/testtask'
require File.dirname(__FILE__) + '/lib/freydis/version'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

# Usage: rake gem:build
namespace :gem do
  desc 'build the gem'
  task :build do
    Dir['freydis*.gem'].each { |f| File.unlink(f) }
    system('gem build freydis.gemspec')
    system("gem install --user-install freydis-#{Freydis::VERSION}.gem -P HighSecurity")
  end
end

task :default => :test
