require 'dropbox_sdk'

class HomeController < ApplicationController
  
  def index
    if session[:dropbox_session] then
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      if not dbsession.authorized? then
        #redirect_to :controller => 'dropbox', :action => 'authorize'
        respond_to do |format|
          format.html {redirect_to :controller => 'dropbox', :action => 'authorize'}
        end
      else
        respond_to do |format|
          format.html
        end
      end
    else
      respond_to do |format|
        format.html { render :template => 'home/login' }
      end
    end
  end
end
