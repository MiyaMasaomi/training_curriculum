class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    #getWeekから変更
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
    #requireの中に入れるのはモデル名なので、calendarsは不適切になる。modelsにあるplanに変更
  end

  def get_week
    #indexのgetWeekをget_weekに修正したため上記も修正
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日
    @wday = Date.today.wday
    #曜日の指定
    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end    
      #上記のeach文では、日付に関しての文でtimesメソッドに含まれる形、曜日とは別

      wday_num = @wday + x
      if wday_num >= 7
        wday_num = wday_num -7
      end
      #7を超える可能性があるため対応、またtimesメソッドに使われるブロック変数xのみをこちらで使っている
      #37から40行目に関しては43から46と接点はない、理由はDate.todayとDate.today.wdayで出力されるものが違うから
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wday: wdays[wday_num]}
      #上記のハッシュロケットをシンボル型に変更
      # 曜日を表示するためwday: wdays[wday_num]を追加
      @week_days.push(days)
    end

  end
end
