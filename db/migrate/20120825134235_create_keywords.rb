class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name
      t.integer :category_id

      t.timestamps
    end
  end
end
