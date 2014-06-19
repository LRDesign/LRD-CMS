# encoding: utf-8

class ImageUploader < PaperclipUploader
  include CarrierWave::RMagick

  version :original do
    # Just create an unaltered version of the original image
  end

  version :large do
    process :resize_to_fill => [800, 800]
  end

  version :thumb do
    process :resize_to_fill => [100, 100]
  end

  version :icon do
    process :resize_to_fill => [50, 50]
  end

end
