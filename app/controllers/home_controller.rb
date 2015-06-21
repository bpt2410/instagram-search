class HomeController < ApplicationController
  before_filter :authentication, :only => [:search]
  before_filter :logined, :only => [:index]

  def index
  end

  def instagram
    redirect_to Instagram.authorize_url(:redirect_uri => APP_CONFIG['instagram_redirect_callback'])
  end

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => APP_CONFIG['instagram_redirect_callback'])
    Media.set_access_token(response.access_token)
    redirect_to search_path
  end

  def search
    if request.format == :json
      message = 'success'
      media = Media.new(Media.access_token)
      current_location if params[:currentPos].present? && params[:currentPos] == 'true'
      @medias = []

      if params[:lat].present? && params[:lng].present?
        options = params[:distance].present? ? { :distance => params[:distance] } : {}
        @medias = media.search(params[:lat], params[:lng], options)
      end

      if @medias.blank?
        @medias = []
        message = 'fail'
      end

    end

    respond_to do |format|
      format.html
      format.json { render json: { message: 'success', results: @medias } }
    end
  end

  def coding_challenge
  end

  private

  def current_location
    begin
      if location = request.location
        params[:lat] = location.latitude
        params[:lng] = location.longitude
      end
    rescue
    end
  end
end
