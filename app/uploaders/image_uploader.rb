# encoding: utf-8

class ImageUploader < PaperclipUploader
  include CarrierWave::RMagick

  version :thumb do
    process :resize_to_fill => [100, 100]
  end

end
