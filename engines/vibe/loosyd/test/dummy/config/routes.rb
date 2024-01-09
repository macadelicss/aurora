Rails.application.routes.draw do
  mount Loosyd::Engine => "/loosyd"
end
