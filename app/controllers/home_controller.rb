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
    Media.save_access_token(response.access_token)
    redirect_to search_path
  end

  def search
    media = Media.new(Media.access_token)
    @medias = []
    if params[:lat].present? && params[:lng].present?
      options = params[:distance].present? ? { :distance => params[:distance] } : {}

      @medias = media.search(params[:lat], params[:lng], options)
    end
    count = @medias.count
    @number_page = count % 12 == 0 ? count / 12 : count / 12 + 1
  end

  def coding_challenge
  end
end
