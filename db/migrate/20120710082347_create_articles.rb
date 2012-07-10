class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :line
      t.string :url
      t.string :src
      t.string :news_time
      t.string :genre
      t.string :cat
      t.string :subcat
      t.string :tag
      t.text :memo

      t.timestamps
    end
  end
end
