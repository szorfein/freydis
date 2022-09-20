# frozen_string_literal: true

module Freydis
  module Secrets
    class GPG
      include Exec
      include Msg

      attr_reader :seckey_path, :pubkey_path

      def initialize
        @recipient = Guard.gpg(CONFIG.gpg_recipient)
        @seckey_path = "/tmp/#{@recipient}-secret.key"
        @pubkey_path = "/tmp/#{@recipient}-public.key"
      end

      def export_keys
        info "Exporting keys for #{@recipient}..."
        gpg "-a --export-secret-keys --armor #{@recipient} >#{@seckey_path}"
        gpg "-a --export --armor #{@recipient} >#{@pubkey_path}"
      end

      def import_keys(prefix = nil)
        is_key = `gpg -K | grep #{@recipient}`.chomp
        if is_key.empty?
          info "Importing key #{@recipient}..."
          gpg_import(prefix)
        else
          info "Key #{@recipient} is alrealy present, skip import."
        end
      end

      def clean_keys(prefix = nil)
        if prefix
          shred "#{prefix}#{@seckey_path}", "#{prefix}#{@pubkey_path}"
        else
          shred @seckey_path, @pubkey_path
        end
        success "Clean keys."
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
          error "Exe: gpg #{command}"
        end
      end
    end
  end
end
