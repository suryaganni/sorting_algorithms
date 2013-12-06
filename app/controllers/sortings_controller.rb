class SortingsController < ApplicationController

  def index
    @sorting = Sorting.new
  end

  def sort_data
    @sorting = Sorting.new(params[:sorting])
    @sorting.sort_list
    render :action => :index
  end

end
