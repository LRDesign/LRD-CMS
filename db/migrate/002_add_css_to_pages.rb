class AddCssToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :css, :text
  end

  def self.down
    remove_column :pages, :css
  end
end
