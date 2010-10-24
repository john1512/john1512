class CreateHelps < ActiveRecord::Migration

  def self.up
    create_table :helps do |t|
      t.text :content
      t.integer :position

      t.timestamps
    end

    add_index :helps, :id

    load(Rails.root.join('db', 'seeds', 'helps.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:name => "Helps"})

    Page.delete_all({:link_url => "/helps"})

    drop_table :helps
  end

end
