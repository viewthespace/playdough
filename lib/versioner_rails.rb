require 'versioner_rails/version'

module VersionerRails

  def versioner mod
    self.prepend_before_filter do
      if request.accept
        version = request.headers['HTTP_X_VERSIONER'].present? ? request.headers['HTTP_X_VERSIONER'].to_i : 1
        shape = request.headers['HTTP_X_SHAPE']
        mod_version = mod.const_get("V#{version}")
        if shape
          load "app/serializers/#{mod.to_s.underscore}/v#{version}/#{mod.to_s.underscore}_#{shape}_serializer.rb"
          klass = mod_version.constants.map{ |c| c.to_s.underscore }.select{|s| s[/_(\w+)_serializer$/, 1] == shape }.first
        else
          load "app/serializers/#{mod.to_s.underscore}/v#{version}/#{mod.to_s.underscore}_serializer.rb"
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
