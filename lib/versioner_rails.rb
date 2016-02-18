require 'versioner_rails/version'

module VersionerRails

  def versioner mod
    self.prepend_before_filter do
      if request.accept
        version = request.accept[/version\s?=\s?(\d+)/, 1]
        shape = request.accept[/shape\s?=\s?(\w+)/, 1]
        mod_version = mod.const_get("V#{version}")
        if shape
          @versioner_serializer = mod_version.const_get("#{mod.name}#{shape.capitalize}Serializer")
        else
          @versioner_serialzier = mod_version.const_get("#{mod.name}Serializer")
        end
      end
    end
  end

end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    attr_accessor :versioner_serializer
    extend VersionerRails
  end
end
