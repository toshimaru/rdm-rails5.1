class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    render plain: "hello world!"
  end
end
