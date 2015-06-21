require 'rails_helper'

RSpec.describe Media, type: :model do
  before(:each) do
    @media = Media.new('2014979139.9bcceb2.5de11bcc8b9b41759ab3ce2b46703ddf')
  end

  it 'create new Media successfully' do
    expect(@media.access_token).to eq '2014979139.9bcceb2.5de11bcc8b9b41759ab3ce2b46703ddf'
  end

  it 'set and get access_token in redis' do
    Media.set_access_token('123456789')
    token = Media.access_token
    expect(token).to eq '123456789'
  end

  it 'authentication instagram fail' do
    Media.set_access_token('123456789')
    expect(Media.authentication?).to eq false
  end

  it 'authentication instagram true' do
    Media.set_access_token('2014979139.9bcceb2.5de11bcc8b9b41759ab3ce2b46703ddf')
    expect(Media.authentication?).to eq true
  end

  it 'distance between two location with incorrect paramerters' do
    distance = @media.distance(10, 30)
    expect(distance).to eq 999999
  end

  it 'distance between two location with correct paramerters' do
    distance = @media.distance([12.1, 13.2], [12.1, 13.2])
    expect(distance).to eq 0
  end

  it 'search post with incorrect paramerters' do
    posts = @media.search(nil, nil, nil)
    expect(posts).to eq nil
  end

  it 'search post with incorrect coordinates' do
    posts = @media.search('11111', '11111111')
    expect(posts).to eq nil
  end

  it 'search post with correct coordinates' do
    posts = @media.search('37.947178', '-122.362617')
    expect(posts.length).to be > 0
  end

  it 'check result for search post with correct coordinates' do
    posts = @media.search('37.947178', '-122.362617')
    expect(posts.first).to_not be_nil
  end

end
