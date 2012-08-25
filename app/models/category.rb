class Category < ActiveRecord::Base
  
  belongs_to :genre
  has_many :keyword
  
end#class Category < ActiveRecord::Base
