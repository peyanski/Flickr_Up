
require 'flickraw'
require 'find'
require 'yaml'



APP_CONFIG = YAML.load_file("config.yml")['defaults']

if APP_CONFIG['target_dir'].nil? or APP_CONFIG['target_dir'].empty? or !File.exists? APP_CONFIG['target_dir']
  puts "Your target_dir: options is empty or config.yml doesn't exist."
  exit
end

FlickRaw.api_key = APP_CONFIG['api_key']
FlickRaw.shared_secret = APP_CONFIG['shared_secret']
flickr.access_token = APP_CONFIG['access_token']
flickr.access_secret = APP_CONFIG['access_secret']
target_dir = APP_CONFIG['target_dir']
photoset_id = APP_CONFIG['photoset_id']
#target_dir = './photo/'



if !File.exists?('uploaded_files.yml') or File.zero? ('uploaded_files.yml') # if the file doesn't exist or it's empty
  puts "Your 'uploaded_files.yml' is empty or doesn't exist..."
  puts "Creating 'uploaded_files.yml' file!"
  uploaded = File.new("uploaded_files.yml", "w+")    # open file for read and write
  uploaded.puts("Uploaded")    
  uploaded.close
  #exit
end
thing = YAML.load_file('uploaded_files.yml') # load all yml file
#thing = IO.readlines('uploaded_files.yml') # use this one if you don't have yaml module

Find.find(target_dir) do |file|
  
  if !FileTest.directory?(file)
    
    #puts thing.inspect
	md5 = Digest::MD5.file(file).hexdigest  # get md5 checksum of the file
	filename = File.basename file 			# get only the filename without full path
	if not APP_CONFIG['allowed_ext'].include? File.extname(filename) 
		puts "Skipping '#{filename}' due to restriction in config.yml"
		File.open('skipped_files.yml', 'a') { |new_file| new_file.puts(file) } # all skipped files goes to a file
	else
		if !thing.include?(md5)
		  puts "Start uploading #{filename} ..."
		  begin 
			picture_id = flickr.upload_photo file, :title => filename, :description => "", 
												  #:tags =>encoded_tags.join(' '), 
							:is_public => APP_CONFIG['is_public'],
							:is_friend => APP_CONFIG['is_friend'],
							:is_family => APP_CONFIG['is_family'],
							:hidden => APP_CONFIG['hidden']

		  #rescue Timeout::Error,Selenium::WebDriver::Error::NoSuchElementError => e
		  #retry
			rescue StandardError,Timeout::Error => e
			  puts "Exception #{e.class} : #{e}"
			  File.open('exceptions.yml', 'a') { |new_file| new_file.puts(file.to_s + ' - ' + e.to_s) } 
			  puts "I am rescued"
			#raise e
			#retry
		  end
		
		
		  if picture_id
			puts "\t upload done."
			# adding uploaded photo to photoset configured in config.yml
			res = flickr.call "flickr.photosets.addPhoto", {'photoset_id' => photoset_id, 'photo_id' => picture_id}
		  end
		  puts "Adding #{file} to uploaded_files.yml"
		  File.open('uploaded_files.yml', 'a') { |new_file| new_file.puts(file.to_s + ' ' + md5) }
		else
			puts "md5: #{md5} already exist - #{filename}"
		end
    end
  end
end  
puts "Congrats!"

