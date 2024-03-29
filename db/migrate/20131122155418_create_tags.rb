class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :slug
      t.string :category

      t.timestamps
    end
    add_index :tags, :slug
  end
end
