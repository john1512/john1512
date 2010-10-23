class PagesController < ApplicationController

  before_filter :find_latest_news_items, :only => [:home]

  protected

  def find_latest_news_items
    @news_items = NewsItem.latest.limit(2)
  end
end
