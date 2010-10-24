require 'refinery'

module Refinery
  module Helps
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end
      
      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "helps"
          plugin.activity = {:class => Help,}
        end
      end
    end
  end
end
