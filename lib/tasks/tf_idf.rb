require 'pry'
require 'pp'
def getTF(entry)
  tf = Hash.new(0)
  n = 0
  entry.entry_word_relations.each do |relation|
    next unless relation.word.pos === "名詞"
    n += 1
    tf[relation.word.surface_form] += 1
  end
  tf.each do |key, val|
    tf[key] = val/n.to_f
  end
  return tf
end

def getTfIdf(tf)
  tf_idf = Hash.new(0)
  tf.each do |key, val|
    tf_idf[key] = val * Word.find_by(surface_form: key, pos: "名詞").idf
  end
  return tf_idf
end

def setIdf
  entries_count = Entry.count
  word_count = Word.where(pos: "名詞").count
  Word.where(pos: "名詞").each_with_index do |word, index|
    next if word.idf.present?
    puts "#{index}/#{word_count}"
    word.update(idf: (entries_count/word.entry_word_relations.count.to_f)+1)
  end
end

# Keyword.delete_all
entry_count = Entry.all.count
setIdf
Entry.all.each_with_index do |entry, index|
  puts "#{index}/#{entry_count}"
  next if entry.keywords.present?
  tf = getTF(entry)
  tf_idf = getTfIdf(tf)
  tf_idf = tf_idf.sort_by{|k, v| v}.reverse
  tf_idf.each_with_index do |val, n|
    break if n >= 10
    word = Word.find_by(surface_form: val[0], pos: "名詞")
    Keyword.create(entry_id: entry.id, word_id: word.id, score: val[1])
  end
end