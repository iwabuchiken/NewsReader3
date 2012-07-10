module BASICS

    # REF => 黒田・佐藤: 98
    # REF => http://stackoverflow.com/questions/4589968/ruby-rails-how-to-check-if-a-var-is-an-integer
    def self.is_numeric?(obj) 
        obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
  
end