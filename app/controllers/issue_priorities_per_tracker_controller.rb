class IssuePrioritiesPerTrackerController < ApplicationController
  unloadable
  
  layout 'admin'
  before_filter :require_admin
  before_filter :find_tracker_and_issue_priority, :only => [:link, :unlink]

  def index
    @trackers = Tracker.all
    @issue_priorities = IssuePriority.find(:all)
  end

  def link
    if @relation.blank?
      @relation = IssuePrioritiesTracker.new
      @relation.tracker = @tracker
      @relation.issue_priority = @issue_priority
      @relation.save
    end
    render :partial => "checkbox", :locals => { :tracker => @tracker, :issue_priority => @issue_priority, :issue_priority_included => true }
  end

  def unlink
    if not @relation.blank?
      @relation.destroy
    end
    render :partial => "checkbox", :locals => { :tracker => @tracker, :issue_priority => @issue_priority, :issue_priority_included => false }
  end
  
  private
  
  def find_tracker_and_issue_priority
    @tracker = Tracker.find(params[:tracker])
    @issue_priority = IssuePriority.find(params[:issue_priority])
    @relation = IssuePrioritiesTracker.find(:first, :conditions => {:tracker_id => @tracker.id, :issue_priority_id => @issue_priority.id})
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
