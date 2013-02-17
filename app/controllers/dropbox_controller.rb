require 'dropbox_sdk'

# This is an example of a Rails 3 controller that authorizes an application
# and then uploads a file to the user's Dropbox.

class DropboxController < ApplicationController
    def authorize
=begin      if session[:dropbox_session] then
        dbsession = DropboxSession.deserialize(session[:dropbox_session])
        if not dbsession.authorized? then
          dbsession.get_access_token  #we've been authorized, so now request an access_token
          session[:dropbox_session] = dbsession.serialize
        end

        redirect_to :controller => 'home', :action => 'index', :notice => 'loged in!'
      else
        dbsession = DropboxSession.new(APP_KEY, APP_SECRET)
        session[:dropbox_session] = dbsession.serialize #serialize and save this DropboxSession
        #pass to get_authorize_url a callback url that will return the user here
        redirect_to dbsession.get_authorize_url url_for(:action => 'authorize')
      end
=end
      if not params[:oauth_token] then
        #dbsession = DropboxSession.new(Droplayer::APP_KEY, Droplayer::APP_SECRET)
        dbsession = DropboxSession.new(Droplayer::APP_KEY, Droplayer::APP_SECRET)

        session[:dropbox_session] = dbsession.serialize #serialize and save this DropboxSession

        #pass to get_authorize_url a callback url that will return the user here
        redirect_to dbsession.get_authorize_url url_for(:action => 'authorize')
      else
        # the user has returned from Dropbox
        dbsession = DropboxSession.deserialize(session[:dropbox_session])
        dbsession.get_access_token  #we've been authorized, so now request an access_token
        session[:dropbox_session] = dbsession.serialize

        redirect_to :controller => 'home', :action => 'index', :notice => 'loged in!'
      end
    end
    
    def search
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      client = DropboxClient.new(dbsession, Droplayer::ACCESS_TYPE)
      begin
        file_metadata = client.metadata('/')
        media_share = []
=begin        file_metadata['contents'].collect do |x|
          x['media_share'] = client.media(x['path'])
        end
        puts 'media share '+file_metadata.inspect
=end
        @songs = file_metadata['contents'].map {|attr| Song.new(attr)}
      rescue DropboxError => err
        @songs = 'error'
      end
              
      respond_to do |format|
        format.html { render :text => '<pre>'+JSON.pretty_generate(file_metadata)+'</pre>' }
        format.json { render :json => @songs }
      end
    end
    
    def media_link
      if not params[:path] then
        @media = nil
      else
        dbsession = DropboxSession.deserialize(session[:dropbox_session])
        client = DropboxClient.new(dbsession, Droplayer::ACCESS_TYPE)
        begin
          @media = client.media(params[:path])
        rescue DropboxError
          @media = nil
        end
      end
      
      respond_to do |format|
        format.json { render :json => @media }
      end
    end
end
