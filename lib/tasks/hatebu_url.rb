require 'nokogiri'
require 'open-uri'
require 'csv'

url = 'http://b.hatena.ne.jp/hotentry/'#切り出すURLを指定します。
urls = []
20141112.upto(20151112) do |day|
  begin
    url = "http://b.hatena.ne.jp/hotentry/#{day}"
    puts url
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    page = Nokogiri::HTML.parse(html, nil, charset)
    page.css('a.entry-link').each do |link|
      urls << link.attributes["href"].value
    end
  rescue
    next
  end
end
# ファイルへ書き込み
File.write('hatebu_urls.txt', urls.join(","))