class Public::OrdersController < ApplicationController

  include ApplicationHelper
  before_action :authenticate_customer!

  def index
    @orders = current_customer.orders
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def new
    @order = Order.new
    @addresses = current_customer.addresses
  end

  def confirm
    @cart_items = CartItem.where(customer_id:[current_customer.id])
    @postage = 800
    @total = 0

    @order = Order.new(
      customer_id: current_customer.id,
      payment_method: params[:order][:payment_method])

    # my_addressに1が入っていれば（自宅）
    if params[:order][:my_address] == "1"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.full_name

    # my_addressに2が入っていれば（配送先一覧）
    elsif params[:order][:my_address] == "2"
      ship = Address.find(params[:order][:address_id])
      @order.postal_code = ship.postal_code
      @order.address = ship.address
      @order.name = ship.name

    # my_addressに3が入っていれば(新配送先)
    elsif params[:order][:my_address] == "3"
      @order.postal_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]

    # 有効かどうかの確認
      unless @order.present?
        @addresses = Address.where(customer: current_customer)
        render :new
      end
    end
  end



  def create
    @order = current_customer.orders.new(order_params)
    @order.save

    # 情報入力に新規配送先があれば保存
    if params[:order][:ship] =="1"
      current_customer.address.create(address_params)
    end

       # カート商品の情報を注文履歴に移動させる
    @cart_items = current_customer.cart_items
    @cart_items.each do |cart_item| #カートの商品を1つずつ取り出しループ
      @order_detail = OrderDetail.new #初期化宣言
      @order_detail.item_id = cart_item.item_id #商品idを注文商品idに代入
      @order_detail.order_id = @order.id #注文商品に注文idを紐付け
      @order_detail.amount = cart_item.amount #購入数を注文商品数に代入
      @order_detail.price = (cart_item.item.price * 1.1).to_i #消費税込みに計算して代入
      @order_detail.save
    end
    # 最後にカートを全て削除する
    @cart_items.destroy_all

    redirect_to '/orders/thanks'
  end

  def thanks
  end

  private
  def order_params
    params.require(:order).permit(:postal_code, :address, :name, :payment_method, :total_payment)
  end

  def address_params
    params.require(:order).permit(:postal_code, :address, :name)
  end
end
