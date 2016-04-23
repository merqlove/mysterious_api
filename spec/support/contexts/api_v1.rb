require 'spec_helper'

RSpec.shared_context 'api_v1' do
  let(:schema_url_prefix) { '/api/v1' }

  let(:last_response) { response }
  let(:last_request) { request }
  let(:schema_path) { "#{Rails.root}/docs/v1/schema.json" }
end
