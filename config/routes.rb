ActionController::Routing::Routes.draw do |map|
  map.connect 'admin/issue_priorities_per_tracker/:action/:id', :controller => 'issue_priorities_per_tracker'
end

