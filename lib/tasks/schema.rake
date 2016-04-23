require 'prmd/rake_tasks/combine'
require 'prmd/rake_tasks/verify'
require 'prmd/rake_tasks/doc'

namespace :api do
  namespace :v1 do
    namespace :schema do
      Prmd::RakeTasks::Combine.new do |t|
        t.options[:meta] = 'docs/v1/meta.json'
        # use meta.yml if you prefer YAML format
        t.paths << 'docs/v1/schemata'
        t.output_file = 'docs/v1/schema.json'
      end

      Prmd::RakeTasks::Verify.new do |t|
        t.files << 'docs/v1/schema.json'
      end

      Prmd::RakeTasks::Doc.new do |t|
        t.options[:prepend] = ['docs/v1/overview.md']
        t.files = {'docs/v1/schema.json' => 'docs/api_v1.md'}
      end

      task default: %w(schema:combine schema:verify schema:doc)
    end

  end
end
