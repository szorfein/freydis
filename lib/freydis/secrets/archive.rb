# frozen_string_literal: true

require 'date'
require 'fileutils'

module Freydis
  module Secrets
    # Create or Restore an archive of secrets with bsdtar
    class Archive
      include Exec
      include Msg

      def initialize(gpg)
        @workdir = '/mnt/freydis/secrets'
        @filename = "#{@workdir}/#{OPTIONS[:gpg_recipient]}_#{Date.today}.tar.gz"
        @restore_dir = '/tmp'
        @include_paths = %w[]
        @gpg = gpg
      end

      def create
        populate_include
        inc_paths = @include_paths * ' '

        mkdir @workdir
        info "Creating archive #{@filename}..."
        bsdtar "--acls --xattrs -cpvf #{@filename} #{inc_paths}"
        @gpg.clean_keys
      end

      # Restore the most recent archive in your $HOME
      def restore
        last_archive = find_last_archive
        error 'No archive found.' unless last_archive

        mkdir @restore_dir
        info "Restoring #{last_archive}..."
        bsdtar "-xvf #{last_archive} -C #{@restore_dir}"
        @gpg.import_keys @restore_dir
        @gpg.clean_keys @restore_dir
      end

      protected

      def populate_include
        @gpg.export_keys unless File.exist? @gpg.seckey_path
        search_paths(%W[#{ENV['HOME']}/.password-store 
                     #{@gpg.seckey_path}
                     #{@gpg.pubkey_path}])
      end

      def find_last_archive
        if Process.uid == 0
          Dir.glob("#{@workdir}/#{CONFIG.gpg_recipient}*").sort[0]
        else
          archive = `sudo ls #{@workdir}/ | grep #{CONFIG.gpg_recipient} | sort | head -1`.chomp
          "#{@workdir}/#{archive}" if archive
        end
      end

      private

      def search_paths(paths)
        paths.each do |p|
          if Dir.exist?(p) || File.exist?(p)
            info "Found #{p}, add to archive..."
            @include_paths << p
          end
        end
      end
    end
  end
end
