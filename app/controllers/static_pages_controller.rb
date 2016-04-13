class StaticPagesController < ApplicationController

  def home
    if user_signed_in?
      @document = Document.new
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
