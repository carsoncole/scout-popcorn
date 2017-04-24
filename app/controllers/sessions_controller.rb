class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
    redirect_to home_path if current_scout
    @scout = Scout.new
  end

  def create
    scout = Scout.find_by(email: params[:email])
    if scout && scout.authenticate(params[:password])
      session[:scout_id] = scout.id
      scout.update(
        sign_in_count:      scout.sign_in_count += 1, 
        current_sign_in_at: Time.now, 
        last_sign_in_at:    scout.current_sign_in_at,
        last_sign_in_ip:    scout.current_sign_in_ip,
        current_sign_in_ip: request.ip
      )
      redirect_to home_path, notice: 'Logged in!'
    else
      @scout = Scout.new
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

  def destroy
    session[:scout_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end