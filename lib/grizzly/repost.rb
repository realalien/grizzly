
# TODO: what's the difference with the 'status', HOW can I reuse the class Status?
module Grizzly
    class Repost < Grizzly::Base
        API_COLLECTION_NAME = "reposts"
        
        def initialize(data)
            super(data)
            @data["retweeted_status"] = Grizzly::Status.new(data["retweeted_status"]) unless data["retweeted_status"].nil?
        end
        
    end
end
