class Public::SearchController < ApplicationController
  # before_action :authenticate_customer!

  def search
    @content = params[:content]
    @method = params[:method]
    @records = Item.search_for(@content, @method)
  end
end
