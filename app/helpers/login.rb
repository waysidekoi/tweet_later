helpers do

  def login(user, password)
    @user = User.find(user.id)
    if password == @user.password
      session[:current_user_id] = @user.id
    else
      false
    end
  end


end
