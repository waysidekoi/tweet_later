class TweetWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(user_id, status)
    user  = User.find(user_id)

    tweet = Tweet.create(text: status)
    user.tweets << tweet

    client(user).update(status)
  end


  def client(user)
    Twitter::Client.new(
      :consumer_key => ENV['CONSUMER_KEY'],
      :consumer_secret => ENV['CONSUMER_SECRET'],
      :oauth_token => user.user_token,
      :oauth_token_secret => user.user_secret )
  end

end


    # set up Twitter OAuth client here
    # actually make API call
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here
