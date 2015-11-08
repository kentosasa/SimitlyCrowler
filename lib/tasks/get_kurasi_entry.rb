require 'pry'
require 'open-uri'
require 'uri'
require 'rss'
require 'open_uri_redirections'
require 'nokogiri'

def getTags(var)
  tags = {}
  return nil if var["bookmarks"].blank?
  var["bookmarks"].each do |val|
    tagArray = val["tags"]
    tagArray.each do |tag|
      if tags.has_key?(tag)
        tags[tag] = tags[tag] + 1
      else
        tags[tag] = 1
      end
    end
  end
  return tags
end

#Faraday初期化
conn = Faraday::Connection.new(:url => 'http://b.hatena.ne.jp/entry/json/') do |builder|
  builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
  # builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
  builder.use FaradayMiddleware::FollowRedirects
  builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
end

#Faraday初期化
result = []
rss = nil

# リダイレクトして、うまくいかなかったのでopen-urlのミドルウェアを使う
open(URI.escape("http://b.hatena.ne.jp/entrylist/life?mode=rss&threshold=50&sort=recent"), :allow_redirections => :all) do |f|
  rss = RSS::Parser.parse(f.read)
end
#rss = conn.get "https://b.hatena.ne.jp/search/text?q=#{tag}&mode=rss&threshold=30&sort=recent"
rss.items.each do |item|
  entry = {}
  res = conn.get 'http://b.hatena.ne.jp/entry/json/', {:url => item.about}
  res = JSON.parse(res.body)
  entry[:link] = item.about
  entry[:description] = item.description
  entry[:content_encoded] = item.content_encoded
  entry[:screenshot] = res["screenshot"]
  entry[:count] = res["count"]
  entry[:tags] = getTags(res)
  diff_raw = conn.get 'http://api.diffbot.com/v3/article', {url: item.about, token: '47559598aeae1c9c3f51374299178952'}
  diff_res = JSON.parse(diff_raw.body)
  entry[:content] = diff_res['objects'][0]['text']
  entry[:title] = diff_res['objects'][0]['title']
  entry[:content_encoded] = diff_res['objects'][0]['html']
  begin
    entry[:screenshot] = diff_res['objects'][0]['images'][0]['url']
  rescue
    entry[:screenshot] = res["screenshot"]
  end
  puts entry
  result << entry
end

result.each do |data|
  entry = Entry.where(title: data[:title])
  if entry.present?
    entry.last.update(title: data[:title])
    entry = entry.last
  else
    entry = Entry.create(title: data[:title])
  end
  meta = entry.entry_meta
  if meta.present?
    meta.update(count: data[:count], category: 'life')
  else
    meta = EntryMeta.create(count: data[:count], category: 'life', entry_id: entry.id)
  end
  content = entry.entry_content
  if content.present?
    content.update(content: data[:content], thumbnail: data[:screenshot], description: data[:description])
  else
    content = EntryContent.create(content: data[:content], thumbnail: data[:screenshot], description: data[:description], entry_id: entry.id)
  end
end
