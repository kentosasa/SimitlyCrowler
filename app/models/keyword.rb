class Keyword < ActiveRecord::Base
  belongs_to :entry
  belongs_to :word
end
