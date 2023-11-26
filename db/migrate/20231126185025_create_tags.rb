class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.integer :count, default: 0

      t.timestamps
    end

    add_index :tags, :count
  end
end
