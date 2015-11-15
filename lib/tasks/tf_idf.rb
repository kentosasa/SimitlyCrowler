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

def getDF(entry, tf)
  idf = Hash.new(0)
  entries_count = Entry.count
  tf.each do |key, val|
    word = Word.find_by(surface_form: key, pos: "名詞")
    idf[key] = Math.log(entries_count/word.entry_word_relations.count.to_f) + 1
  end
  return idf
end

def getTfIdf(tf, idf)
  tf_idf = Hash.new(0)
  tf.each do |key, val|
    tf_idf[key] = val * idf[key]
  end
  return tf_idf
end

# Keyword.delete_all
entry_count = Entry.all.count
Entry.all.each_with_index do |entry, index|
  puts "#{index}/#{entry_count}"
  next if entry.keywords.present?
  tf = getTF(entry)
  idf = getDF(entry, tf)
  tf_idf = getTfIdf(tf, idf)
  tf_idf = tf_idf.sort_by{|k, v| v}.reverse
  tf_idf.each_with_index do |val, n|
    break if n >= 10
    word = Word.find_by(surface_form: val[0], pos: "名詞")
    Keyword.create(entry_id: entry.id, word_id: word.id, score: val[1])
  end
end