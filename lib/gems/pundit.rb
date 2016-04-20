Pundit::PolicyFinder.prepend(
    Module.new do
      def param_key
        to_check = object.is_a?(Array) ? object.last : object

        if to_check.respond_to?(:model_name)
          to_check.model_name.param_key.to_s
        elsif to_check.is_a?(Class)
          to_check.to_s.demodulize.underscore
        else
          to_check.class.to_s.demodulize.underscore
        end
      end
    end
)
