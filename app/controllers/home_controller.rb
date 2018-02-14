class HomeController < ApplicationController
  def index
    render plain: "hello world!"
  end
end
