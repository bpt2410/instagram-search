require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe 'GET #index when not login' do
    before(:each) do
      Media.set_access_token('123456789')
    end

    it 'responds successfully with an HTTP 200 status code' do
      Media.set_access_token('123456789')
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #index when logined' do
    before(:each) do
      Media.set_access_token('2014979139.9bcceb2.5de11bcc8b9b41759ab3ce2b46703ddf')
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :index
      response.should redirect_to :search
    end
  end

  describe 'GET #coding_challenge' do
    it 'responds successfully with an HTTP 200 status code' do
      get :coding_challenge
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the coding_challenge template' do
      get :coding_challenge
      expect(response).to render_template('coding_challenge')
    end
  end

  describe 'GET #search with format html' do

    before(:each) do
      Media.set_access_token('2014979139.9bcceb2.5de11bcc8b9b41759ab3ce2b46703ddf')
    end

    it 'redirect to index when not login' do
      Media.set_access_token('123456789')
      get :search, { format: :html }
      response.should redirect_to :root
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :search, { format: :html }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the search template' do
      get :search, { format: :html }
      expect(response).to render_template('search')
    end
  end

  describe 'GET #search with format json' do

    before(:each) do
      Media.set_access_token('2014979139.9bcceb2.5de11bcc8b9b41759ab3ce2b46703ddf')
    end

    it 'responds successfully with an HTTP 200 status code' do
      post :search, { format: :json }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the search with format json when incorrect paramerters' do
      post :search, { format: :json }
      results = JSON.parse(response.body)
      expect(results['message']).to eq 'success'
      expect(results['results'].count).to eq 0
    end

    it 'renders the search with format json when correct paramerters' do
      post :search, { format: :json, lat: '37.947178', lng: '-122.362617' }
      results = JSON.parse(response.body)
      expect(results['message']).to eq 'success'
      expect(results['results'].count).to be > 0
    end
  end

end
