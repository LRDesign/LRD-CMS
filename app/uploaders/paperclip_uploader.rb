# encoding: utf-8

class PaperclipUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip

  if Rails.env != "test"
    def paperclip_path
      ":rails_root/public/system/:class/:attachment/:id_partition/:style/:basename.:extension"
    end
  end

end
  