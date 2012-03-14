class CreateIssuePrioritiesTrackers < ActiveRecord::Migration
  def self.up
    create_table :issue_priorities_trackers do |t|
      t.references :issue_priority, :nil => false
      t.references :tracker, :nil => false
      t.column :position, :int, :nil => false, :default => 0
    end
  end

  def self.down
    drop_table :issue_priorities_trackers
  end
end
