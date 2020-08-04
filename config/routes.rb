Rails.application.routes.draw do
<<<<<<< HEAD
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  root 'application#hello'
=======
  root 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
>>>>>>> static-pages
end
