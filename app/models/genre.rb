class Genre < ActiveRecord::Base
  has_many :category
  has_many :keywords
  
end#class Genre < ActiveRecord::Base
