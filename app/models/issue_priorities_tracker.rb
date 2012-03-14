class IssuePrioritiesTracker < ActiveRecord::Base
  unloadable
  belongs_to :tracker
  belongs_to :issue_priority
end
