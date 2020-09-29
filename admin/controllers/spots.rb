Ft8reporter::Admin.controllers :spots do
  get :index do
    @title = "Spots"
    @spots = Spot.all
    render 'spots/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'spot')
    @spot = Spot.new
    render 'spots/new'
  end

  post :create do
    @spot = Spot.new(params[:spot])
    if (@spot.save rescue false)
      @title = pat(:create_title, :model => "spot #{@spot.id}")
      flash[:success] = pat(:create_success, :model => 'Spot')
      params[:save_and_continue] ? redirect(url(:spots, :index)) : redirect(url(:spots, :edit, :id => @spot.id))
    else
      @title = pat(:create_title, :model => 'spot')
      flash.now[:error] = pat(:create_error, :model => 'spot')
      render 'spots/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "spot #{params[:id]}")
    @spot = Spot[params[:id]]
    if @spot
      render 'spots/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'spot', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "spot #{params[:id]}")
    @spot = Spot[params[:id]]
    if @spot
      if @spot.modified! && @spot.update(params[:spot])
        flash[:success] = pat(:update_success, :model => 'Spot', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:spots, :index)) :
          redirect(url(:spots, :edit, :id => @spot.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'spot')
        render 'spots/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'spot', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Spots"
    spot = Spot[params[:id]]
    if spot
      if spot.destroy
        flash[:success] = pat(:delete_success, :model => 'Spot', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'spot')
      end
      redirect url(:spots, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'spot', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Spots"
    unless params[:spot_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'spot')
      redirect(url(:spots, :index))
    end
    ids = params[:spot_ids].split(',').map(&:strip)
    spots = Spot.where(:id => ids)
    
    if spots.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Spots', :ids => "#{ids.join(', ')}")
    end
    redirect url(:spots, :index)
  end
end
