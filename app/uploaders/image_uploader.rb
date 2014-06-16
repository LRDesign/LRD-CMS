# encoding: utf-8

class ImageUploader < PaperclipUploader
  include CarrierWave::RMagick

  version :thumb do
    process :resize_to_fill => [100, 100]
  end

  version :icon do
    process :resize_to_fill => [50, 50]
  end

end
