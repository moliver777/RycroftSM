class AddIssueSkipToStaffAndHorses < ActiveRecord::Migration
  def change
    add_column :staffs, :skip_issues, :boolean, :default => false
    add_column :horses, :skip_issues, :boolean, :default => false
  end
end
