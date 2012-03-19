require_dependency 'issues_controller'

module IssuesControllerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)
    
    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      build_new_issue_from_params_method = instance_method(:build_new_issue_from_params)
      define_method :build_new_issue_from_params do
        build_new_issue_from_params_method.bind(self).call()
        @priorities = @issue.tracker.issue_priorities
      end
      
      define_method :show do
        @journals = @issue.journals.find(:all, :include => [:user, :details], :order => "#{Journal.table_name}.created_on ASC")
        @journals.each_with_index {|j,i| j.indice = i+1}
        @journals.reverse! if User.current.wants_comments_in_reverse_order?
    
        if User.current.allowed_to?(:view_changesets, @project)
          @changesets = @issue.changesets.visible.all
          @changesets.reverse! if User.current.wants_comments_in_reverse_order?
        end
    
        @relations = @issue.relations.select {|r| r.other_issue(@issue) && r.other_issue(@issue).visible? }
        @allowed_statuses = @issue.new_statuses_allowed_to(User.current)
        @edit_allowed = User.current.allowed_to?(:edit_issues, @project)
        @priorities = @issue.tracker.issue_priorities
        @time_entry = TimeEntry.new(:issue => @issue, :project => @issue.project)
        respond_to do |format|
          format.html { render :template => 'issues/show' }
          format.api
          format.atom { render :template => 'journals/index', :layout => false, :content_type => 'application/atom+xml' }
          format.pdf  { send_data(issue_to_pdf(@issue), :type => 'application/pdf', :filename => "#{@project.identifier}-#{@issue.id}.pdf") }
        end
      end
      
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
  end
end