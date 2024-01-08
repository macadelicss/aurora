module CloudNine
  class Engine < ::Rails::Engine
    isolate_namespace CloudNine
    initializer 'cloud_nine.assets.precompile' do |app|
      app.config.assets.paths << root.join('app', 'assets').to_s
    end
  end
end
