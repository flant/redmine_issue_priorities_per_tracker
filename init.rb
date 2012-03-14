require 'redmine'
require File.dirname(__FILE__) + '/lib/tracker_patch.rb'
require File.dirname(__FILE__) + '/lib/issues_controller_patch.rb'
require File.dirname(__FILE__) + '/lib/hooks.rb'
require 'dispatcher'

Redmine::Plugin.register :redmine_issue_priorities_per_tracker do
  name 'Redmine Issue Priorities Per Tracker plugin'
  author 'Andrey Kolashtov <andrey.kolashtov@flant.ru>'
  description 'This is a plugin for Redmine which allows to define issue priorities per tracker.'
  version '0.0.1'
  url 'https://github.com/flant/redmine_issue_priorities_per_tracker'
  author_url 'https://github.com/kolashtov'
  
  menu :admin_menu, :issue_priorities_per_tracker, { :controller => 'issue_priorities_per_tracker' }, :caption => :label_issue_priorities_per_tracker
end

# Add patch
# Using dispatcher cause of recreation of model classes without patch on second request in development environment.
# With dispatcher patch applies on model classes on every request.
Dispatcher.to_prepare do
  Tracker.send(:include, TrackerPatch)
  IssuesController.send(:include, IssuesControllerPatch)
end
