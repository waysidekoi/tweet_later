class User < ActiveRecord::Base
  has_many :tweets

  def tweet(interval, status)
    TweetWorker.perform_in(interval, self.id, status)
  end

end
