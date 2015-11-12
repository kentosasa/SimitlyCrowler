class Api::V1::EntriesController < ApplicationController
  def index
    render json: Entry.joins(:entry_content).joins(:entry_meta).all
  end

  def links
    url = params[:url]
    title = params[:title]
    text = params[:text]
    max = 30
    tf = getTf(text)
    idf = getIdf(tf)
    tf_idf = getTfIdf(tf, idf)
    data = []


    tf_idf.each_with_index do |val, n|
      break if data.count >= max
      begin
        word = Word.find_by(surface_form: val[0], pos: "名詞")
        word.keywords.each do |relation|
          data << relation.entry
        end
        rescue
          next
        end
    end
    data = data.uniq
    data.concat(Entry.all.sample(max - data.count)) if max > data.count
    res = []

    data.each do |en|
      begin
        raw = {title: en.title, screenshot: en.entry_content.thumbnail, link: en.entry_content.url, description: en.entry_content.description, count: 1, created_at: en.created_at}
        res << raw
      rescue
        next
      end
    end
    render json: res
  end

  private
  def getTf(text)
    natto = Natto::MeCab.new
    tf = Hash.new(0)
    n = 0
    natto.parse(text).each_line do |word|
      begin
        raw = word.to_s.split(" ")
        val = raw[1].split(',')
        next unless val[0] == "名詞"
        n += 1
        tf[raw[0]] += 1
      rescue
        next
      end
    end
    tf.each do |key, val|
      tf[key] = val/n.to_f
    end
    return tf
  end

  def getIdf(tf)
    idf = Hash.new(0)
    entries_count = Entry.count
    tf.each do |key, val|
      begin
        word = Word.find_by(surface_form: key, pos: "名詞")
        idf[key] = Math.log(entries_count/word.entry_word_relations.count.to_f) + 1
      rescue
        next
      end
    end
    return idf
  end

  def getTfIdf(tf, idf)
    tf_idf = Hash.new(0)
    tf.each do |key, val|
      tf_idf[key] = val * idf[key]
    end
    return tf_idf.sort_by{|k, v| v}.reverse
  end
end