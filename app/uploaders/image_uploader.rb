# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip
  include CarrierWave::MiniMagick
  
  version :thumb do
    process :resize_to_fill => [100, 100]
  end

end
