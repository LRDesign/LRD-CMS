require 'generators/rspec'
require 'rails/generators/resource_helpers'
 
module Rspec
  module Generators
    class Rspec::Generators::ScaffoldGenerator
      p "reopening rspec scaffold generator"
      
      # replace copy view with one that explicitly doesn't put the
      # template engine in the file name
      def copy_view(view)
        template "#{view}_spec.rb",
                 File.join("spec/views", controller_file_path, "#{view}.html_spec.rb")
      end      
    end        
    p ScaffoldGenerator.namespace
    p "ancestors: " +ScaffoldGenerator.ancestors.join(", ")
  end
end
