class Word < ActiveRecord::Base
  has_many :entry_word_relations
  has_many :entries, :through => :entry_word_relations
end
