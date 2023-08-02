class Public::ItemsController < ApplicationController

  def index
    @genres = Genre.all
    if params[:genre_id]
      @genre = @genres.find(params[:genre_id])
      all_items = @genre.items
    else
      all_items = Item.all
    end
    @page_items = all_items.page(params[:page]).per(8)
    @all_items_count = all_items.count
  end

  def show
    @item = Item.find(params[:id])
    @genres = Genre.all
    @cart_item = CartItem.new
  end

  private

  def items_params
    parmas.require(:item).permit(:genre_id, :name, :introduction, :price, :is_sold, :image_id)
  end
end
