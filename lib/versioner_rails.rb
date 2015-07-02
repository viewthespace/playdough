require 'versioner_rails/version'

module VersionerRails

  def versioner mod
    self.prepend_before_action do
      if request.accept
        version = request.accept[/version\s?=\s?(\d+)/, 1].to_i
        shape = request.accept[/shape\s?=\s?(\w+)/, 1]
        mod_version = mod.constants.select{ |c| c.to_s == "V#{version}" }.map{ |c| mod.const_get(c) }.first
        if shape
          klass = mod_version.constants.map{ |c| c.to_s.underscore }.select{|s| s[/_(\w+)_serializer$/, 1] == shape }.first
        else
          type = mod.to_s.demodulize.underscore
          klass = mod_version.constants.map{ |c| c.to_s.underscore }.select{|s| "#{type}_serializer" == s }.first
        end
        @versioner_serializer = mod_version.const_get(klass.classify)
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
