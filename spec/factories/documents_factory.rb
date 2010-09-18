Factory.define :document, :class => Admin::Upload::Document do |document|
  document.data_file_name 'dummy'
  document.data_file_size 1
  document.data_content_type 'fake/fake'
end
