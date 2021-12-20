#!/usr/bin/ruby

require 'time'
require 'nkf'

abort "Usage:#{$0} PodcastTitle PublicURL FilesDir" if ARGV.length < 3

title = NKF.nkf('-w', ARGV[0])
location = ARGV[1]
filesDir = ARGV[2]

files = [];
Dir.glob(File.join(filesDir, '*.{mp3,m4a,aac}')) do |path|
  name = File.basename(path, File.extname(path))
  item = { 'path'   => path,
           'name'   => name,
           'fname'  => File.basename(path),
           'time'   => File.ctime(path),
           'length' => File.size(path) }
  files << item
end

files = files.sort do |a, b|
  a['time'] <=> b['time']
end

puts <<EOS
<?xml version="1.0" encoding="utf-8"?>
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
  <channel>
    <title>#{title}</title>
EOS

files.each do |item|
  url = location + item['fname']

  if (/\.mp3$/ =~ item['fname']) then
    mime = 'audio/mp3'
  elsif (/\.webm$/ =~ item['fname']) then
    mime = 'audio/webm'
  else
    mime = 'audio/mp4'
  end

  puts <<-EOS
    <item>
      <title>#{item['name']}</title>
      <enclosure url="#{url}"
                 length="#{item['length']}"
                 type="#{mime}" />
      <guid isPermaLink="true">#{url}</guid>
      <pubDate>#{item['time'].rfc822}</pubDate>
    </item>
  EOS
end

puts <<EOS
  </channel>
</rss>
EOS
