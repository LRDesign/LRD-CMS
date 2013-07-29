# encoding: utf-8

class ImageUploader < PaperclipUploader
  include CarrierWave::MiniMagick

  version :thumb do
    process :resize_to_fill => [100, 100]
  end

end
