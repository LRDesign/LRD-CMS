# encoding: utf-8

class ImageUploader < SystemUploader
  include CarrierWave::RMagick

  version :thumb do
    process :resize_to_fill => [100, 100]
  end

  version :icon do
    process :resize_to_fill => [50, 50]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
