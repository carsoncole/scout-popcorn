class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
    redirect_to home_path if current_scout
    @scout = Scout.new
    if params[:reset_token]
      scout = Scout.find_by_password_reset_token(params[:reset_token])
      if scout
        scout.update(
          password_reset_token: nil
          sign_in_count:      scout.sign_in_count += 1, 
          last_sign_in_at:    Time.now,
          last_sign_in_ip:    request.remote_ip,
          )
        session[:scout_id] = scout.id
        redirect_to scout_update_password_path(scout), alert: 'Please change your password'
      else
        redirect_to root_path, alert: 'Something is wrong with your reset request link. Please try again and only use the most recent email reset link.'
      end
    end
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