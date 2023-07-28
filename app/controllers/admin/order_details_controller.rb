class Admin::OrderDetailsController < ApplicationController
   before_action :authenticate_admin!

  def update
    @order_detail = OrderDetail.find(params[:id]) #特定
    @order_detail.update(order_detail_params) #製作ステータスの更新
    @order = @order_detail.order #注文商品から注文テーブルの呼び出し

    # 制作ステータスを「製作中(2)」→注文ステータスを「製作中(2)」
    if @order_detail.making_status == "製作中" #製作ステータスが「製作中」なら入る
      @order.update(status: 2) #注文ステータスを「製作中」に更新
      flash[:notice] = "製作ステータスを更新しました。"
      @order.save
    end

    # 注文個数と制作完了になっている個数が同じならば
    # 上記の条件に当てはまらなければ、商品の個数の特定　　　　製作ステータスが「製作l完了」の商品をカウント
    # 数が一致すれば、全ての商品の製作ステータスが「製作完了」だとわかる
    if @order.order_details.count == @order.order_details.where(making_status: 3).count
      @order.update(status: 3) #注文ステータスを「発送準備中]に更新
      flash[:notice] = "製作ステータスを更新しました。"
      @order.save
    end

   redirect_to admin_order_path(@order) #注文詳細に遷移
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:order_id, :making_status, :amount)
  end
end