require 'generators/rspec'
require '../rspec-rails.gemspec/../lib/generators/rspec/scaffold/scaffold_generator'
require 'rails/generators/resource_helpers'

module Rspec           
  module Generators
    class ScaffoldGenerator < Base
                  
      protected 
      # replace copy view with one that explicitly doesn't put the
      # template engine in the file name
      def copy_view(view)
        template "#{view}_spec.rb",
                 File.join("spec/views", controller_file_path, "#{view}.html_spec.rb")
      end      
    end        
  end
end
