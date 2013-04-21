module Grizzly
  class Client
    def initialize(access_token = nil)
      raise Grizzly::Errors::NoAccessToken.new unless access_token
      @access_token = access_token
    end

		def user(user_id)
      request = Grizzly::Request.new(:get, "/users/show", { :access_token => @access_token, :uid => user_id })
      Grizzly::User.new request.response 
		end
    
    def friends(user_id)
      Grizzly::Cursor.new(Grizzly::User, "/friendships/friends", {:access_token => @access_token, :uid => user_id})
    end

    def bilateral_friends(user_id)
      Grizzly::Cursor.new(Grizzly::User, "/friendships/friends/bilateral", {:access_token => @access_token, :uid => user_id})
    end

    def status_update(status)
			if status.nil?
				e = Grizzly::Errors::Arguement.new
				e.add_error({ :status =>  "You must set a status" })
				raise e
			end
      request = Grizzly::Request.new(:post, "/statuses/update", { :access_token => @access_token }, { :status => status } )
      Grizzly::Status.new request.response 
    end
      
    def comments(status_id)
      Grizzly::Cursor.new(Grizzly::Comment, "/comments/show", {:access_token => @access_token, :id => status_id})
    end
    
    def user_of_screen_name(screen_name)
      request = Grizzly::Request.new(:get, "/users/show", { :access_token => @access_token, :screen_name => screen_name })
      Grizzly::User.new request.response 
    end
    
    def search_suggestions_users(query_str, return_count=50)
       request = Grizzly::Request.new(:get, "/search/suggestions/users", {:access_token => @access_token, :q => query_str, :count => return_count })
       users = request.response.map{|e| Grizzly::User.new(e) } || []
    end
  end
end
