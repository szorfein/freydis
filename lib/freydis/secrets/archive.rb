# frozen_string_literal: true

require 'date'
require 'fileutils'

module Freydis
  module Secrets
    # Create or Restore an archive of secrets with bsdtar
    class Archive
      def initialize(gpg)
        @workdir = '/mnt/freydis/secrets'
        @filename = "#{@workdir}/#{CONFIG.gpg_recipient}_#{Date.today}.tar.gz"
        @restore_dir = '/tmp'
        @include_paths = %w[]
        @gpg = gpg
      end

      def create
        populate_include
        inc_paths = @include_paths * ' '

        mkdir @workdir
        Msg.info "Creating archive #{@filename}..."
        bsdtar "--acls --xattrs -cpvf #{@filename} #{inc_paths}"
        @gpg.clean_keys
      end

      # Restore the most recent archive in your $HOME
      def restore
        last_archive = Dir.glob("#{@workdir}/*").sort[0]

        mkdir @restore_dir
        Msg.info "Restoring #{last_archive}..."
        bsdtar "-xvf #{last_archive} -C #{@restore_dir}"
        @gpg.import_keys
        @gpg.clean_keys
      end

      protected

      def populate_include
        @gpg.export_keys unless File.exist? @gpg.seckey_path
        search_paths(%W[#{ENV['HOME']}/.password-store 
                     #{@gpg.seckey_path}
                     #{@gpg.pubkey_path}])
      end

      private

      def search_paths(paths)
        paths.each do |p|
          if Dir.exist?(p) || File.exist?(p)
            Msg.info "Found #{p}, add to archive..."
            @include_paths << p
          end
        end
      end

      def bsdtar(args)
        sudo = Process.uid == 0 ? '' : 'sudo'
        unless system("#{sudo} bsdtar #{args}")
          Msg.error "Exe: bsdtar #{args}"
        end
      end

      def mkdir(dir)
        if Process.uid == 0
          FileUtils.mkdir_p dir
        else
          unless system("sudo mkdir -p #{dir}")
            Msg.error "Fail to create #{dir}"
          end
        end
      end
    end
  end
end
