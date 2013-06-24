require 'git-media/transport'
require 'net/dav'

# git-media.transport webdav
# git-media.webdavusername
# git-media.webdavpassword
# git-media.webdavurl

module GitMedia
  module Transport
    class Webdav < Base

      def initialize(url, username, password)
        
        @url = url

        @username = username
        @password = password

        @webdav = Net::DAV.new(url)
        @webdav.credentials(@username, @password)

      end

      def exist?(file)
        @webdav.exists?(file)
      end

      def read?
        return true
      end

      def get_file(sha, to_file)

        to = File.new(to_file, File::CREAT|File::RDWR)
        if self.exist?(sha)
        
          @webdav.get(sha) do |stream|
            to.write(stream)
          end
          to.close
          return true
        
        end
        return false
      end

      def write?
        return true
      end

      def put_file(sha, from_file)

        if File.exists?(from_file)
        
          File.open(from_file, "r") do |stream|
            @webdav.put(sha, stream, File.size(from_file))
          end
          return true

        end
        return false

      end  
      
      def get_unpushed(files)
        files.select do |f|
          !self.exist?(f)
        end
      end
      
    end
  end
end
