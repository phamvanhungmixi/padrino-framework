module Padrino
  module Generators

    class AdminPage < Thor::Group
      attr_accessor :orm

      # Add this generator to our padrino-gen
      Padrino::Generators.add_generator(:admin_page, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "padrino-gen admin_page [Model]"; end

      # Include related modules
      include Thor::Actions
      include Padrino::Generators::Actions
      include Padrino::Generators::Admin::Actions

      desc "Description:\n\n\tpadrino-gen admin_page YourModel"
      argument :model, :desc => "The name of your model"
      class_option :skip_migration, :aliases => "-s", :default => false, :type => :boolean
      class_option :root, :desc => "The root destination", :aliases => '-r', :type => :string
      class_option :destroy, :aliases => '-d', :default => false, :type => :boolean

      # Show help if no argv given
      require_arguments!

      # Create controller for admin
      def create_controller
        self.destination_root = options[:root]
        if in_app_root?
          @orm ||= Padrino::Admin::Generators::Orm.new(model, adapter)
          self.behavior = :revoke if options[:destroy]
          ext = fetch_component_choice(:renderer)

          template "templates/page/controller.rb.tt",       destination_root("/admin/controllers/#{@orm.name_plural}.rb")
          template "templates/#{ext}/page/_form.#{ext}.tt", destination_root("/admin/views/#{@orm.name_plural}/_form.#{ext}")
          template "templates/#{ext}/page/edit.#{ext}.tt",  destination_root("/admin/views/#{@orm.name_plural}/edit.#{ext}")
          template "templates/#{ext}/page/index.#{ext}.tt", destination_root("/admin/views/#{@orm.name_plural}/index.#{ext}")
          template "templates/#{ext}/page/new.#{ext}.tt",   destination_root("/admin/views/#{@orm.name_plural}/new.#{ext}")

          add_project_module(@orm.name_plural)
        else
          say "You are not at the root of a Padrino application! (config/boot.rb not found)" and return unless in_app_root?
        end
      end
    end # AdminPage
  end # Generators
end # Padrino