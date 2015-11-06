require 'pry'
require 'open-uri'
require 'uri'
require 'rss'
require 'open_uri_redirections'
require 'natto'

natto = Natto::MeCab.new
natto.parse("俺の名前はベジータだ") do |n|
  binding.pry
  n.feature.split(',')
  puts "#{n.surface}\t#{n.feature}"
end
natto.parse