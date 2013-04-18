get '/' do
  erb :index
end

get '/oauth' do
  @consumer = create_consumer
  session[:request_token] = @consumer.get_request_token(:oauth_callback => 'http://localhost:9393/auth')
  redirect session[:request_token].authorize_url
end

get '/auth' do

  @access_token = session[:request_token].get_access_token(oauth_verifier: params[:oauth_verifier])
  session.delete(:request_token) 

  @user = User.create(username: @access_token.params[:screen_name].downcase, 
                      user_token: @access_token.token, 
                      user_secret: @access_token.secret)
  
  session[:current_user_id] = @user.id

  redirect '/tweet'
end

get '/tweet' do
  erb :logged_in
end

post '/tweet' do
  params[:now] ? interval = 0 : interval = params[:interval]+"."+params[:unit_of_time]
  user = User.find(session[:current_user_id])
  user.tweet(interval, params[:tweet])
end


post '/login' do
  user = User.find_by_email(params[:email].downcase)

  if authenticate(user, params[:password])
    redirect '/tweet'
  else
    redirect '/'
  end

end

get '/logout' do
  session.clear
  erb :index
end

get '/status/:job_id' do
  if job_is_complete(params[:job_id])
    return "Done!"
  else
    return "Working on it!"
  end 

end

get '/signup' do

  erb :signup

end

post '/signup' do

  user = User.create(username: params[:username], email: params[:email], password: params[:password])
  login(user, params[:password])
  redirect '/'
end
