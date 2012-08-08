class AssignmentController < ApplicationController
  skip_before_filter :application_status
  skip_before_filter :setup

  def block
    block = SiteSetting.where(:name => "block_auto_assign_prompt").first
    block.value = Date.today.to_s
    block.save!
    render :nothing => true
  end

  def auto_assign
  end
end