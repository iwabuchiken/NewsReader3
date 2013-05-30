class AddColumnGenreIdToKeyword < ActiveRecord::Migration
  def up
    add_column :keywords, :genre_id, :integer
  end
  
  def down
    remove_column :keywords, :genre_id
  end
end#class AddColumnGenreIdToKeyword < ActiveRecord::Migration
