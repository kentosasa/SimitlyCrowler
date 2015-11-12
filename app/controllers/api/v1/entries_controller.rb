class Api::V1::EntriesController < ApplicationController
  def index

    render json: Entry.joins(:entry_content).joins(:entry_meta).all
  end

  def links
    url = params[:url]
    en = Entry.last
    data = []
    10.times do |n|
      raw = {title: en.title, screenshot: en.entry_content.thumbnail, link: en.entry_content.url, description: en.entry_content.description, count: 1, created_at: en.created_at}
      data << raw
    end
    render json: Entry.all
  end
  # count = 0
  # Keyword.delete_all
  # Entry.all.each do |entry|
  #   tf = getTF(entry)
  #   idf = getDF(entry, tf)
  #   tf_idf = getTfIdf(tf, idf)
  #   tf_idf = tf_idf.sort_by{|k, v| v}.reverse
  #   tf_idf.each_with_index do |val, n|
  #     break if n >= 10
  #     count += 1
  #     puts count
  #     word = Word.find_by(surface_form: val[0], pos: "名詞")
  #     Keyword.crea  te(entry_id: entry.id, word_id: word.id, score: val[1])
  #   end
  # end
end