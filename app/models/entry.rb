class Entry < ActiveRecord::Base
  has_one :entry_meta
  has_one :entry_content
  has_many :entry_word_relations
  has_many :words, through: :entry_word_relations
  has_many :keywords
end
