class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
    redirect_to home_path if current_scout
    @scout = Scout.new
  end

  def create
    scout = Scout.active.find_by(email: params[:email].downcase)
    if scout && scout.authenticate(params[:password])
      session[:scout_id] = scout.id
      scout.update(
        sign_in_count:      scout.sign_in_count += 1, 
        last_sign_in_at:    Time.now,
        last_sign_in_ip:    request.remote_ip,
      )
      redirect_to home_path
    else
      @scout = Scout.new
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

  def destroy
    session[:scout_id] = nil
    redirect_to root_url
  end
end