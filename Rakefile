require 'rubygems'
require 'aws/s3'
require 'yaml'

def version_file
  File.join('content', 'VERSION')
end

def s3_settings
  f = File.read('.s3.yml')
  YAML.load(f)
end

def s3_bucket
  s3_settings['bucket']
end

def s3_upload s3_filename, local_filename
  bucket = s3_bucket
  
  puts "#{bucket}: Uploading #{s3_filename}"
  AWS::S3::S3Object.store(s3_filename, open(local_filename), bucket, :access => :public_read)
end

namespace :s3 do
  
  task :init => [:connect, :test]
  
  task :connect do
    s3 = s3_settings
    
    AWS::S3::Base.establish_connection!(
      :access_key_id     => s3["access_key_id"],
      :secret_access_key => s3["secret_access_key"]
    )
  end
  
  task :test do
    AWS::S3::Service.buckets
  end
  
end

namespace :plugin do
  
  task :version do
    commit_hash = `git rev-parse HEAD`
    File.open(version_file, 'w') {|f| f.write commit_hash }
  end
  
  desc 'create the xpi'
  task :package => ['plugin:version'] do
    `./build_mac.sh`
  end
  
  desc 'upload the xpi to amazon s3'
  task :upload => ['s3:init'] do
    xpi = File.join('mobile-remote.xpi')
    s3_upload "mobile-remote-edge.xpi", xpi
    s3_upload 'EDGE-VERSION', version_file
  end
  
  desc 'package and upload the xpi to amazon s3'
  task :deploy => ['plugin:package', 'plugin:upload', 'plugin:clean'] do
    
  end
  
  desc 'remove all the plugin build files'
  task :clean do
    # FileUtils.rm(version_file)
    # FileUtils.rm('mobile-remote.xpi')
  end
  
end
