require File.dirname(__FILE__) + '/rspec_default_values'

module Rspec
  module Lrd
    module Generators
      class Factory < Rails::Generators::NamedBase 
        # p "defining the factory scaffold generator"
    
        include Rails::Generators::ResourceHelpers
        source_root File.dirname(__FILE__) + '/templates'
      
        argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"        

        def create_root_folder
          empty_directory File.join("spec/factories")
        end

        def copy_factory_file
          filename = "#{controller_file_name}_factory.rb"        
          template 'factory.rb', File.join("spec/factories", filename)
          say "templating filename #{filename}"          
        end

        protected

        def available_views
          %w(index edit show new _form)
        end
      
        def filename_with_extensions(name)
          "#{name}.html.haml"
        end
     
      end
      # p Factory.namespace
    
    end
  end
end