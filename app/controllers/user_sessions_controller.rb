class UserSessionsController < ApplicationController
  # GET /user_sessions/new
  def new
    @user_session = UserSession.new
  end

  # POST /user_sessions
  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      redirect_to(:root, :notice => 'Login successful.') 
    else
      render :action => "new" 
    end
  end

  # DELETE /user_sessions
  def destroy
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy

      redirect_to(:root, :notice => 'Logout successful.')
    else
      redirect_to(:root)
    end
  end
end
