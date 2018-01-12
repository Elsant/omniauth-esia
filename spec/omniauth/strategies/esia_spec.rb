require 'spec_helper'

RSpec.describe OmniAuth::Strategies::Esia, :type => :strategy do

  let(:request) { double('Request', :params => {}, :cookies => {}, :env => {}) }

  subject do
    args = ['client_id', @options || {}].compact
    OmniAuth::Strategies::Esia.new(*args).tap do |strategy|
      allow(strategy).to receive(:request) { request }
    end
  end

  it 'has a version number' do
    expect(OmniAuth::Esia::VERSION).not_to be nil
  end

  describe 'client options' do
    it 'should have correct name' do
      expect(subject.options.name).to eq('esia')
    end

    it 'should have correct site' do
      expect(subject.options.client_options.site).to eq('https://esia.gosuslugi.ru')
    end

    it 'should have correct authorize url' do
      expect(subject.options.client_options.authorize_url).to eq('aas/oauth2/ac')
    end

    it 'should have correct token url' do
      expect(subject.options.client_options.token_url).to eq('aas/oauth2/te')
    end
  end
end
