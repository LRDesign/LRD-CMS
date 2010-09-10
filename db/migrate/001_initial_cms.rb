class InitialCms < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string   :title
      t.string   :permalink
      t.text     :content
      t.boolean  :published
      
      t.text :keywords
      t.text :description
      
      t.datetime :edited_at
      t.timestamps
    end
    
    create_table :locations do |t|
      t.string :name
      t.string :path
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :page_id

      t.timestamps
    end
    
    create_table :users do |t|              
      t.string    :login,               :null => false,  :limit => 20
      t.string    :email,               :null => false  
      t.string    :first_name,          :limit => 60
      t.string    :last_name,           :limit => 60

      # Authlogic stuff
      t.string    :crypted_password,    :null => false                # optional, see below
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability

      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns

      t.timestamps
    end
    
    create_table :documents do |t|
      t.string :data_file_name
      t.integer :data_file_size
      t.string :data_content_type
      t.datetime :data_updated_at

      t.timestamps
    end    
  end

  def self.down
    drop_table :pages
    drop_table :locations
    drop_table :users
    drop_table :documents
  end
end
