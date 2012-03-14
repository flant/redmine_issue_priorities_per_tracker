require_dependency 'tracker'

module TrackerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)
    
    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      has_many :issue_priorities_trackers
      has_many :issue_priorities, :through => :issue_priorities_trackers   
    end
  end
  
  module ClassMethods
    
  end
  
  module InstanceMethods
  end
end