module PaperclipPathFixer
  def self.included(base)
    if Rail.env != "test"
      base.define_method :paperclip_path do
        ":rails_root/public/system/:class/:attachment/:id_partition/:style/:basename.:extension"
      end
    end
  end
