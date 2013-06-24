require 'yaml'
require 'rubygems'
require 'find'
require 'digest/md5'


APP_CONFIG = YAML.load_file("config.yml")['defaults']

if APP_CONFIG['target_dir'].nil? or APP_CONFIG['target_dir'].empty? or !File.exists? APP_CONFIG['target_dir']
  puts "Your config upload_path is empty or doesn't exist."
  exit
end

target_dir = APP_CONFIG['target_dir']

sets = []
Find.find(target_dir) do |files|
#Dir.glob("#{APP_CONFIG['target_dir']}*").each do |file|
  #next if file[0] == '.'
  if !FileTest.directory?(files)
    puts 'file is' + files.to_s
  #photosets.each{ |s|
#    data = file.to_s
#    sets << data
#    sets.each { |a| print a }
    
#    File.open('uploaded_files.yml', 'a') do |out|
#      out.write(sets.to_yaml)
#    end

  md5 = Digest::MD5.file(files).hexdigest 
  File.open('uploaded_files.yml', 'a') { |file| file.puts(files.to_s + ' ' + md5)  }
  #md5 = Digest::MD5.hexdigest(File.read(files)) load whole file to RAM
  #md5 = Digest::MD5.file(files).hexdigest
  #puts md5.to_s
  
  end
#  data = files
#  sets << data
#  sets.each { |a| print a }
    
#  File.open('uploaded_files.yml', 'a') { |f|
#    f.puts(sets.to_yaml)
#  }
  
  

  

end
puts "uploaded_files.yml saved."
#all_files = Read_uploaded_files.new
#all_files.get_set_by_title('img')
#all_files.get_set_by_title.show