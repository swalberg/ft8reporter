require 'csv'
module Ft8reporter
	class App < Padrino::Application
		register ScssInitializer
		register Padrino::Mailer
		register Padrino::Helpers
		enable :sessions

		##
		# Caching support.
		#
		# register Padrino::Cache
		# enable :caching
		#
		# You can customize caching store engines:
		#
		# set :cache, Padrino::Cache.new(:LRUHash) # Keeps cached values in memory
		# set :cache, Padrino::Cache.new(:Memcached) # Uses default server at localhost
		# set :cache, Padrino::Cache.new(:Memcached, :server => '127.0.0.1:11211', :exception_retry_limit => 1)
		# set :cache, Padrino::Cache.new(:Memcached, :backend => memcached_or_dalli_instance)
		# set :cache, Padrino::Cache.new(:Redis) # Uses default server at localhost
		# set :cache, Padrino::Cache.new(:Redis, :host => '127.0.0.1', :port => 6379, :db => 0)
		# set :cache, Padrino::Cache.new(:Redis, :backend => redis_instance)
		# set :cache, Padrino::Cache.new(:Mongo) # Uses default server at localhost
		# set :cache, Padrino::Cache.new(:Mongo, :backend => mongo_client_instance)
		# set :cache, Padrino::Cache.new(:File, :dir => Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
		#

		##
		# Application configuration options.
		#
		# set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
		# set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
		# set :show_exceptions, true    # Shows a stack trace in browser (default for development)
		# set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
		# set :public_folder, 'foo/bar' # Location for static assets (default root/public)
		# set :reload, false            # Reload application files (default in development)
		# set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
		# set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
		# disable :sessions             # Disabled sessions by default (enable if needed)
		# disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
		# layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
		#

		##
		# You can configure for a specified environment like:
		#
		#   configure :development do
		#     set :foo, :bar
		#     disable :asset_stamp # no asset timestamping for dev
		#   end
		#

		##
		# You can manage errors like:
		#
		#   error 404 do
		#     render 'errors/404'
		#   end
		#
		#   error 500 do
		#     render 'errors/500'
		#   end
		#
		get '/' do
			render 'index'
		end

		get '/calls', :provides => :json do
      MonitoredCall.all.to_json
    end

    get '/observations', :provides => :json do
      ObservationPeriod.order(Sequel.desc(:run_start)).all.to_json
    end

    get '/dump', :provides => :csv do
      csv_string = CSV.generate(force_quotes: true) do |csv|
        Spot.all.each do |spot|
          csv << spot.to_a
        end
      end
    end

    get '/spots', :provides => :json do
      @obs =  if params[:id]
                ObservationPeriod.where(id: params[:id]).first
              else
                ObservationPeriod.last
              end

      @spots = Spot.where(observation_period_id: @obs.id)
      all = @spots.map do |spot|
        {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [spot.lon, spot.lat]
          },
          properties: {
            band: spot.band,
            name: spot.spotter,
            sender: spot.sender,
            snr: spot.snr
          }
        }
      end
      {
        type: 'FeatureCollection',
        features: all
      }.to_json
    end
  end
end
