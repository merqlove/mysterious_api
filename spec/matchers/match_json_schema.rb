module JsonMatcherHelpers
  def match_response_schema(response, opts)
    data = JSON.parse!(response&.body)

    schema = JsonSchema.parse!(opts[:v1])
    schema.expand_references!

    schema = schema.definitions[opts[:parent]] if opts[:parent]
    schema = if opts[:definition]
      schema.definitions[opts[:definition]]
    elsif opts[:properties]
      schema.definitions[opts[:properties]]
    else
      schema
    end

    validator = JsonSchema::Validator.new(schema)
    result = validator.validate!(data)
    result || result.nil?
  end
end

module CustomMatchers
  def match_json_schema(**opts)
    opts[:v1]      = schema_contents
    opts[:schema_path] = schema_path
    MatchJsonSchema.new(opts)
  end

  def schema_contents
    JSON.parse(File.read(schema_path))
  end

  def schema_path
    raise 'Please override #schema_contents or #schema_path.'
  end

  class MatchJsonSchema
    include JsonMatcherHelpers

    attr_accessor :failure_message

    def initialize(**opts)
      @opts = opts
    end

    def matches?(response)
      match_response_schema(response, @opts)
    rescue => e
      @failure_message = e.message + "\nResponse: " + response&.body + "\nRoot Schema: " + @opts[:parent] + "\n#{@opts[:schema_path]}\n"
      false
    end
  end
end
