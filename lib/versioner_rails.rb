module VersionerRails

  module ClassMethods

    def versioner mod

    end

  end

end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include VersionerRails
  end
end
