require "rubygems"
require "id3lib"
require "fileutils"

class Object
   def blank?
     respond_to?(:empty?) ? empty? : !self
   end
end

class Mp3Renamer
  def initialize(filename)
    @filename = filename
  end

  def rename
    tag = ID3Lib::Tag.new(@filename)
    raise "#{@filename} requires title or track number" if tag.track.blank? && tag.title.blank?
    [tag.track, tag.artist, tag.album, tag.title].select { |t| !t.blank? }.compact.join(' - ').gsub(/\//, '-').strip
  end
end

if ($0 == __FILE__)
  verbose = (ARGV[0] == '-v')
  puts "Started renaming" if verbose
  Dir.glob(File.join('**', '*.mp3')).each do |filename|
    begin
      new_name = File.join(File.dirname(filename), Mp3Renamer.new(filename).rename + ".mp3")
      unless new_name.blank? || filename == new_name
        FileUtils.move(filename, new_name) 
        puts "moved: #{filename} to #{new_name}" if verbose
      end
    rescue Exception => e
      puts e # just output the error
    end
  end
  puts "Completed renaming" if verbose
end

