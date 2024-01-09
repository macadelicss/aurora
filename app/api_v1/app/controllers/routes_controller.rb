class RoutesController < ApplicationController
end
# app/controllers/api/routes_controller.rb
class RoutesController < ApplicationController
  def index
    render json: {
      home_path: aurora_main_home_path,
      dashboard_path: '',
      shop_path: '',
      # Add other routes as needed
    }
  end
end
