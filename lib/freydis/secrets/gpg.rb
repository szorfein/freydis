# frozen_string_literal: true

module Freydis
  module Secrets
    class GPG
      attr_reader :seckey_path, :pubkey_path

      def initialize
        @recipient = Guard.gpg(CONFIG.gpg_recipient)
        @seckey_path = "/tmp/#{@recipient}-secret.key"
        @pubkey_path = "/tmp/#{@recipient}-public.key"
      end

      def export_keys
        Msg.info "Exporting keys for #{@recipient}..."
        gpg "-a --export-secret-keys --armor #{@recipient} >#{@seckey_path}"
        gpg "-a --export --armor #{@recipient} >#{@pubkey_path}"
      end

      def import_keys(prefix = nil)
        is_key = `gpg -K | grep #{@recipient}`.chomp
        if is_key
          Msg.info "Key #{@recipient} is alrealy present, skip import."
        else
          Msg.info "Importing key #{@recipient}..."
          gpg_import(prefix)
        end
      end

      def clean_keys(prefix = nil)
        if prefix
          shred "#{prefix}#{@seckey_path}", "#{prefix}#{@pubkey_path}"
        else
          shred @seckey_path, @pubkey_path
        end
        Msg.success "Clean keys."
      end

      protected

      def gpg_import(prefix)
        if prefix
          gpg "--armor --import #{prefix}#{@seckey_path}"
          gpg "--armor --import #{prefix}#{@pubkey_path}"
        else
          gpg "--armor --import #{@seckey_path}"
          gpg "--armor --import #{@pubkey_path}"
        end
      end

      private

      def gpg(command)
        unless system("gpg #{command}")
          Msg.error "Exe: gpg #{command}"
        end
      end

      def shred(*keys)
        keys_s = keys * ' '
        sudo = Process.uid == 0 ? '' : 'sudo'
        unless system("#{sudo} shred -u #{keys_s}")
          Msg.error "shred -u #{keys_s}"
        end
      end
    end
  end
end
