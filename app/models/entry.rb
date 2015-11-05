class Entry < ActiveRecord::Base
  has_one :entry_meta
  has_one :entry_content
end
