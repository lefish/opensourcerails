ActionController::Routing::Routes.draw do |map|

  map.open_id_complete 'sessions', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.resource :session

  map.resources :users,
    :member => {:activate => :get, :spammer => :put, :edit_password => :get},
    :collection => {:reset_password => :any}

  map.resources :projects,
    :collection => {:upcoming => :get},
    :member => {:submit => :put, :approve => :put, :details => :get, :rate => :post,:download => :get,:activities => :get} do |project|
    project.resources :comments
    project.resource :bookmark
    project.resources :versions, :member => {:set => :put}
    project.resources :screenshots, :member => {:set => :put}
    project.resources :hosted_instances, :member => {:set => :put}
  end

  map.with_options :controller => 'projects'  do |projects|
    projects.activities  "/activities.:format", :action => "activities", :format => nil
    projects.search      "/search",             :action => "search"
    projects.bookmarks   "/bookmarks",          :action => "bookmarks"
    projects.feed        "/feed",               :action => "feed",       :format => "atom"
    projects.connect     "/feed.:format",       :action => "feed"

    # add actions for next/previous project
    projects.next_project     "/projects/:id/next",     :action => "find_next"
    projects.prevous_project  "/projects/:id/previous", :action => "find_previous"
  end

  map.with_options :controller => 'pages' do |pages|
    pages.about "/about", :action => "about"
    pages.blog  "/blog",  :action => "blog"
    # blog
    # map.blog "/blog", :controller => "blog", :action => "index"
    # map.blog_post "/blog/:id", :controller => "blog", :action => "show"

    # email campaign routes
    pages.email_unsubscribed "/unsubscribed", :action => "unsubscribed"
    pages.email_subscribe    "/subscribe",    :action => "subscribe"
  end

  map.forgot_password "/forgot_password", :controller => "users", :action => "forgot_password"

  # set the root to project index
  map.root :controller => "projects"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end