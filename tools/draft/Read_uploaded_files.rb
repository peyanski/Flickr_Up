require 'rubygems'
require 'yaml'


#thing = YAML.load_file('uploaded_files.yml')
thing = IO.readlines('uploaded_files.yml')
#puts thing.inspect


if !thing.include? './photo/New folder/ffffff/bb/IMG_0064.JPG'
  puts 'ehooooo'
end


#class Read_uploaded_files
#  
#  def initialize(name = 'uploaded_files.yml')
#    @data = YAML.load(File.open(name))
#  end
#  
#  def get_set_by_title(title)
#    @data.each{ |s|
#      puts "matching #{s['title']} and #{title}"
#      return s if s["title"] == title
#    }
#    false
#  end
#  
#  def show
#    p @data
#  end
#  all_files = Read_uploaded_files.new
#all_files.get_set_by_title('img')
#all_files.get_set_by_title.show 
#end
