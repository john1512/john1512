#!/usr/ruby

require 'rubygems'
require 'open-uri'
#require 'rss'
require 'nokogiri'
require 'date'

class BlogEntry
	attr_accessor :title , :text , :date , :author , :link_id
end

#from comments, get channel.item.
#	pubDate = date
#	title = title
#	description = text
#	author = author
#	thr:in-reply-to/@href = link_id
#
#	we can match comments to their post by the link id
#
class Comment < BlogEntry
	def initialize(xml)
	#	puts "TYPE!!!#{xml.xpath('pubDate').class}!!!" => nodeset
	#	puts "SIZE!!!#{xml.xpath('pubDate').size}!!!" => 1
	#	puts "STYPE!!!#{xml.xpath('pubDate')[0].class}!!!" => Element (is Node)
	#	puts "meth?!!!#{xml.xpath('pubDate')[0].respond_to?(:content)}!!!" => yes
		
		@date = xml.xpath('pubDate')[0].content.to_s
		@title = xml.xpath('title')[0].content.to_s
		@text = xml.xpath('description')[0].content.to_s
		@author = xml.xpath('author')[0].content.to_s
		@link_id = xml.xpath('thr:in-reply-to', { 'thr' => 'http://purl.org/syndication/thread/1.0' } )[0].attributes['href'].to_s
	end
	
	def process_text()
		process = @text
		
		replaces = {
			'<br />' => "\n",
			'&#39;' => "'"
		}
		replaces.keys.each do |replace_me|
			replace = ''
			replace = process.sub!( replace_me, replaces[replace_me] ) until replace.nil?
		end
		mtext = ''
		lines = process.split("\n")
		lines.each { |line| mtext += "<p>#{line}</p>" }
		
		@date =~ /(.+) \+\d+/
		
		mtext += "<p><em>This comment was originally posted on the Blogger site on #{$1}</em></p>"
		
		mtext
	end
end

#from posts, get channel.item.
#	pubDate = date
#	title = title
#	description = text
#	author = author
#	link = link_id
#	for ea. category, add in to categories
#
class Post < BlogEntry
	
	attr_reader :comments , :categories
	
	def initialize(xml)
		@comments = []
		@categories = []
		
		@date = xml.xpath('pubDate')[0].content.to_s
		@title = xml.xpath('title')[0].content.to_s
		@text = xml.xpath('description')[0].content.to_s
		@author = xml.xpath('author')[0].content.to_s
		@link_id = xml.xpath('link')[0].content.to_s
		
		xml.xpath('category').each { |category| @categories << category.content.to_s }
	end
	
	def process_text()
		process = @text
		
		process =~ /(.+)<div class="blogger-post-footer">.+$/
		process = $1
		
		replaces = {
			'<br />'=>"\n",
		}
		replaces.keys.each do |replace_me|
			replace = ''
			replace = process.sub!( replace_me, replaces[replace_me] ) until replace.nil?
		end
		mtext = ''
		lines = process.split("\n")
		lines.each { |line| mtext += "<p>#{line}</p>" }
		
		@date =~ /(.+) \+\d+/
		
		mtext += "<br /><p><em>This story was originally posted on <a>#{@link_id}</a> on #{$1}</em></p>"
		
		mtext
	end
end

#grab feeds/rss
feeds = {}
feeds[:posts] = 'http://kathycasper.blogspot.com/feeds/posts/default?alt=rss'
feeds[:comments] = 'http://kathycasper.blogspot.com/feeds/comments/default?alt=rss'
rss = {}
feeds.keys.each do |feed|
	content = ''
	open(feeds[feed]) { |f| content = f.read }
	#rss[feed] = RSS::Parser.parse(content, false)
	rss[feed] = Nokogiri::XML(content)
end

#grab comments
puts "!!!found #{rss[:comments].xpath("//item").size}  raw comments"
comments = Hash.new { |h,k| h[k] = [] }
rss[:comments].xpath("//item").each do |item|
	comment = Comment.new(item)
	comments[comment.link_id] << comment
end
comments.keys.each do |post|
	comments[post].sort! do |c1,c2|
		d1= Date.parse( c1.date )
		d2 = Date.parse( c2.date )
		d1 <=> d2
	end
end
puts "!!!created comments:"
comments.keys.each { |post| puts "!!!\t#{post} => #{comments[post].size}" }

#grab posts
puts "!!!found #{rss[:posts].xpath("//item").size} raw posts"
posts = []
rss[:posts].xpath("//item").each do |item|
	post = Post.new(item)
	comments[post.link_id].each { |comment| post.comments << comment }
	posts << post
end
posts.sort! do |p1,p2|
	d1= Date.parse( p1.date )
	d2 = Date.parse( p2.date )
	d1 <=> d2
end
puts "!!!created #{posts.size} posts:"
posts.each { |post| puts "!!!\t#{post.link_id} => #{post.comments.size} comments" }

#TODO- feed in to refinery & disqus
posts.each do |post|
	#TODO- put post into refiner
	post.comments.each do |comment|
		#TODO- put comments into disqus
	end
end

#put output into file to make sure we got everything
File.open( './port_test.txt', 'w+' ) do |testfile|
posts.each do |post|
	testfile.puts '!!!POST:'
	testfile.puts "TITLE:#{post.title}"
	testfile.puts "DATE:#{post.date}"
	testfile.puts "CATEGORIES:#{post.categories.join(',')}"
	testfile.puts "TEXT:\n#{ post.process_text}"
	
	testfile.puts "\nCOMMENTS(#{post.comments.size}):"
	post.comments.each do |comment|
		testfile.puts "\n\tCOMMENT:"
		testfile.puts "\tTITLE:#{comment.title}"
		testfile.puts "\tAUTHOR:#{comment.author}"
		testfile.puts "\tTEXT:\n#{comment.process_text}"
	end
end
end



