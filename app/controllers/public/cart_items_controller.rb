class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @total = 0
    @cart_items = CartItem.where(customer_id:[current_customer.id])
    @genres = Genre.all
  end

  def create
    @cart_item = CartItem.new(cart_items_params)
    @cart_item.customer_id = current_customer.id
    @cart_item_check = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])

    if @cart_item_check
      @cart_item_check.amount += params[:cart_item][:amount].to_i
      @cart_item_check.save
      flash[:success] = "カートに追加しました"
      redirect_to cart_items_path
    else
      @cart_item = CartItem.new(cart_items_params)
      @cart_item.customer_id = current_customer.id
      if @cart_item.save
        flash[:success] = "カートに商品を入れました"
        redirect_to cart_items_path
      else
        flash[:danger] = "個数を入力してください"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def update
    @cart_item = CartItem.find(params["id"])
    @cart_item.update(amount: params[:cart_item][:amount].to_i)
    @cart_item.save
    redirect_to cart_items_path
  end

  def destroy
    @cart_item = CartItem.find(params["id"])
    @cart_item.destroy
    redirect_to cart_items_path
  end

  def all_destroy
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    redirect_to cart_items_path
  end

  private

  def cart_items_params
    params.require(:cart_item).permit(:customer_id, :item_id, :amount)
  end
end
