# encoding: utf-8

class DocUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip

  def store_dir
    ":rails_root/public/system/:class/:attachment/:id_partition"
  end
  
end
