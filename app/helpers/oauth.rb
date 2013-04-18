helpers do
  def create_consumer
    OAuth::Consumer.new(ENV['CONSUMER_KEY'], 
      ENV['CONSUMER_SECRET'], 
      site: "http://api.twitter.com")
  end

  
  def client
    Twitter::Client.new(
      :consumer_key => ENV['CONSUMER_KEY'],
      :consumer_secret => ENV['CONSUMER_SECRET'],
      :oauth_token => session[:user_token],
      :oauth_token_secret => session[:user_secret]
      )
  end

  def logged_in?
    session[:current_user_id].present?
  end

  def job_is_complete(jid)
    waiting = Sidekiq::Queue.new
    working = Sidekiq::Workers.new
    pending = Sidekiq::ScheduledSet.new
    return false if pending.find { |job| job.jid == jid }
    return false if waiting.find { |job| job.jid == jid }
    return false if working.find { |worker, info| info["payload"]["jid"] == jid }
    true
  end
end


