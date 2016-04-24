require 'spec_helper'

RSpec.shared_context 'api_v1' do
  let(:schema_url_prefix) { '/api/v1' }

  let(:last_response) { response }
  let(:last_request) { request }
  let(:schema_path) { schema_path_plain }

  before :all do
    generate_schema unless File.exist?(schema_path_plain)
  end

  def schema_path_plain
    "#{Rails.root}/docs/v1/schema.json"
  end

  def generate_schema
    Rake::Task['api:v1:schema'].invoke
  end
end
