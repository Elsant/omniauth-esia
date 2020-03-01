require 'omniauth-oauth2'
require 'base64'

module OmniAuth
  module Strategies
    class Esia < OmniAuth::Strategies::OAuth2

      option :name, 'esia'
      option :client_id, nil
      option :client_options, {
        site:          'https://esia.gosuslugi.ru',
        authorize_url: 'aas/oauth2/ac',
        token_url:     'aas/oauth2/te',
      }
      option :scope, 'fullname'
      option :key_path, 'config/keys/private.key'
      option :key_passphrase, nil
      option :crt_path, 'config/keys/certificate.crt'
      option :access_type, 'online'

      uid { JWT.decode(access_token.token, nil, false).first['urn:esia:sbj_id'] }

      info do
        {
          first_name:  raw_info['firstName'],
          last_name:   raw_info['lastName'],
          middle_name: raw_info['middleName'],
          email:       raw_info['email']
        }
      end

      extra do
        {
          raw_info: raw_info
        }
      end

      def authorize_params
        super.tap do |params|
          params[:state] = state
          params[:timestamp] = timestamp
          params[:client_secret] = client_secret
          params[:access_type] = options.access_type
          session['omniauth.state'] = state
        end
      end

      def client
        ::OAuth2::Client.new(options.client_id, client_secret, deep_symbolize(options.client_options))
      end

      def raw_info
        @raw_info ||= access_token.get("/rs/prns/#{uid}")&.parsed.merge!(get_email)
      end

      def build_access_token
        code = request.params['code']
        client.auth_code.get_token(code,
          {
            state: state,
            scope: options.scope,
            timestamp: timestamp,
            redirect_uri: callback_url,
            token_type: 'Bearer'
          }
        )
      end

      private

      def client_secret
        @client_secret ||=  Base64.urlsafe_encode64(signed_data)
      end

      def state
        @state ||= SecureRandom.uuid
      end

      def data
        @data ||= "#{options.scope}#{timestamp}#{options.client_id}#{state}"
      end

      def key
        @key ||= OpenSSL::PKey.read(File.read(options.key_path), options.key_passphrase)
      end

      def crt
        @crt ||= OpenSSL::X509::Certificate.new(File.read(options.crt_path))
      end

      def signed_data
        @signed_data ||= key.sign(digester, data)
      end

      def digester
          OpenSSL::Engine.load
          engine = OpenSSL::Engine.by_id('gost')
          engine.set_default(0xFFFF)
          engine.digest('md_gost12_256')
        end

        def timestamp
          @timestamp ||= Time.now.strftime('%Y.%m.%d %H:%M:%S %z')
        end

        def get_email
          { 'email' => access_token
              .get("/rs/prns/#{uid}/ctts?embed=(elements)")
              .parsed.fetch('elements', {})
              .find { |e| e['type'] == 'EML' }
              .fetch('value') }
        rescue => e
          {}
        end
    end
  end
end

OmniAuth.config.add_camelization 'esia', 'Esia'
