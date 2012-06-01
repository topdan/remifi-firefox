require 'bundler'
Bundler.setup
Bundler.require(:default)

require 'yaml'
require 'fileutils'

def version_file
  File.join('content', 'VERSION')
end

def static_manifest_file
  File.join('content', 'static.json')
end

def s3_settings
  f = File.read('.s3.yml')
  YAML.load(f)
end

def s3_bucket
  s3_settings['bucket']
end

def s3_upload s3_filename, local_filename, options = {}
  bucket = s3_bucket
  
  puts "#{bucket}: Uploading #{s3_filename}"
  AWS::S3::S3Object.store(s3_filename, open(local_filename), bucket, options)
end

def compile directory
  Dir.glob(File.join("#{directory}.coffee", '**', '*.coffee')) do |coffee_file|
    puts "  compiling #{coffee_file}"
    
    js_file_src = coffee_file.sub(/\.coffee$/, '.js')
    js_file_dest = js_file_src.sub /^#{directory}.coffee/, directory
    
    FileUtils.mkdir_p File.dirname(js_file_dest)
    unless Kernel.system "coffee -c #{coffee_file} ; mv #{js_file_src} #{js_file_dest}"
      raise "Could not compile #{coffee_file}"
    end
  end
end

def current_version
  @current_version ||= `git rev-parse HEAD`
end

namespace :s3 do
  
  task :init => [:connect]
  
  task :connect do
    s3 = s3_settings
    
    AWS::S3::Base.establish_connection!(
      :access_key_id     => s3["access_key_id"],
      :secret_access_key => s3["secret_access_key"]
    )
  end
  
end

namespace :plugin do
  
  task :version do
    File.open(version_file, 'w') {|f| f.write current_version }
  end
  
  desc 'create the xpi'
  task :package => ['plugin:version', 'plugin:static:manifest'] do
    `./build_mac.sh`
  end
  
  desc "compiles all the coffee script"
  task :compile do
    puts "Compiling CoffeeScript"
    
    compile 'content'
    compile 'apps'
  end
  
  desc 'upload the xpi to amazon s3'
  task :upload => ['s3:init'] do
    name = ENV['NAME'] || 'edge'
    
    xpi = File.join('remifi.xpi')
    s3_upload "/firefox/#{name}.xpi", xpi, :access => :public_read, :content_type => "application/x-xpinstall"
    s3_upload "/firefox/#{name}/#{current_version}.xpi", xpi, :access => :public_read, :content_type => "application/x-xpinstall"
    s3_upload "/firefox/#{name}.version", version_file, :access => :public_read
  end
  
  desc 'package and upload the xpi to amazon s3'
  task :deploy => ['plugin:compile', 'plugin:package', 'plugin:upload', 'plugin:clean'] do
    
  end
  
  desc 'remove all the plugin build files'
  task :clean => 'plugin:static:clean' do
    FileUtils.rm(version_file)
    FileUtils.rm('remifi.xpi')
  end
  
  namespace :static do
    
    task :manifest do
      files = {}
      
      folder_files = File.join 'static', "**", "*"
      Dir[folder_files].each do |file|
        next if File.directory?(file)
        
        files["/#{file}"] = File.mtime(file).to_i
      end
      
      File.open(static_manifest_file, 'w') {|f| f.write files.to_json }
    end
    
    task :clean do
      FileUtils.rm(static_manifest_file)
    end
    
  end
  
end
