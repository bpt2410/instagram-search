module ApplicationHelper

  def logined?
    Media.authentication?
  end
end
