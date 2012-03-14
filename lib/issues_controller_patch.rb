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
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
  end
end