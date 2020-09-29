Ft8reporter::Admin.controllers :monitored_calls do
  get :index do
    @title = "Monitored_calls"
    @monitored_calls = MonitoredCall.all
    render 'monitored_calls/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'monitored_call')
    @monitored_call = MonitoredCall.new
    render 'monitored_calls/new'
  end

  post :create do
    @monitored_call = MonitoredCall.new(params[:monitored_call])
    if (@monitored_call.save rescue false)
      @title = pat(:create_title, :model => "monitored_call #{@monitored_call.id}")
      flash[:success] = pat(:create_success, :model => 'MonitoredCall')
      params[:save_and_continue] ? redirect(url(:monitored_calls, :index)) : redirect(url(:monitored_calls, :edit, :id => @monitored_call.id))
    else
      @title = pat(:create_title, :model => 'monitored_call')
      flash.now[:error] = pat(:create_error, :model => 'monitored_call')
      render 'monitored_calls/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "monitored_call #{params[:id]}")
    @monitored_call = MonitoredCall[params[:id]]
    if @monitored_call
      render 'monitored_calls/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'monitored_call', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "monitored_call #{params[:id]}")
    @monitored_call = MonitoredCall[params[:id]]
    if @monitored_call
      if @monitored_call.modified! && @monitored_call.update(params[:monitored_call])
        flash[:success] = pat(:update_success, :model => 'Monitored_call', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:monitored_calls, :index)) :
          redirect(url(:monitored_calls, :edit, :id => @monitored_call.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'monitored_call')
        render 'monitored_calls/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'monitored_call', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Monitored_calls"
    monitored_call = MonitoredCall[params[:id]]
    if monitored_call
      if monitored_call.destroy
        flash[:success] = pat(:delete_success, :model => 'Monitored_call', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'monitored_call')
      end
      redirect url(:monitored_calls, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'monitored_call', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Monitored_calls"
    unless params[:monitored_call_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'monitored_call')
      redirect(url(:monitored_calls, :index))
    end
    ids = params[:monitored_call_ids].split(',').map(&:strip)
    monitored_calls = MonitoredCall.where(:id => ids)
    
    if monitored_calls.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Monitored_calls', :ids => "#{ids.join(', ')}")
    end
    redirect url(:monitored_calls, :index)
  end
end
