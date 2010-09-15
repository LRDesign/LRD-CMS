
module Lrd
  module Generators
    module Haml 
      class Scaffold < Rails::Generators::NamedBase 
        p "defining the haml scaffold generator"
      
        include Rails::Generators::ResourceHelpers
        
        argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"        

        def create_root_folder
          empty_directory File.join("app/views", controller_file_path)
        end

        def copy_view_files
          available_views.each do |view|
            filename = filename_with_extensions(view)
            template filename, File.join("app/views", controller_file_path, filename)
          end
        end

        protected

          def available_views
            %w(index edit show new _form)
          end
          
          def filename_with_extensions(name)
            "#{name}.html.haml"
          end
      end
  
      p Scaffold.namespace
    end
  end
end
