require 'pry'
require 'open-uri'
require 'uri'
require 'rss'
require 'open_uri_redirections'
require 'natto'
require 'nokogiri'

natto = Natto::MeCab.new
entry_count = Entry.all.count
Entry.all.each_with_index do |en, index|
  puts "#{index}/#{entry_count}だよ"
  begin
    next if en.words.present?
    position = 0
    natto.parse(en.entry_content.content) do |n|
      val = n.feature.split(',')
      word = Word.where(surface_form: n.surface, pos: val[0], basic_form: val[4])
      if word.blank?
        word = Word.create(surface_form: n.surface, pos: val[0], basic_form: val[4])
      else
        word = word.first
      end
      EntryWordRelation.create(entry_id: en.id, word_id: word.id, position: position)
      position += 1
    end
  rescue
    next
  end
end
