class AddColumnCodesToGenre < ActiveRecord::Migration
  def up
    add_column :genres, :code, :string
  end
  
  def down
    remove_column :genres, :code
  end
end
