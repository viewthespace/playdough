module Rails
  class App
    def env_config; {} end
    def routes
      return @routes if defined?(@routes)
      @routes = ActionDispatch::Routing::RouteSet.new
      @routes.draw do
        get '/foo', to: 'foos#index'
        get '/v1/foo', to: 'foos#index'
        get '/v2/foo', to: 'foos#index'
      end
      @routes
    end
  end

  def self.application
    @app ||= App.new
  end
end