Factory.define :image, :class => Admin::Upload::Image do |image|
  image.image_file_name 'dummy'
  image.image_file_size 1
  image.image_content_type 'image/jpeg'
end
