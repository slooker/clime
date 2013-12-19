class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.string :slug
      t.string :content

      t.timestamps
    end
    add_index :collections, :slug
  end
end
