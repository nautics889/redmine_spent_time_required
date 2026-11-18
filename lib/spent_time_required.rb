module SpentTimeRequired
  module Patches
    module IssuesControllerPatch
      def update
        @check = false
        @check_trackers = false
        @check_projects = false

        begin
          if params.has_key?(:time_entry)
            @status = IssueStatus.find(params[:issue][:status_id])
            @tracker_id = params[:issue][:tracker_id].to_i
            @project_id = params[:issue][:project_id].to_i
            @settings = Setting.plugin_spent_time_required



            @check = (
              @settings[:all_statuses] ||
              (
                @settings[:all_closed_statuses] &&
                @status.is_closed?
              ) ||
              (
                @settings[:list_status].has_key?(@status.id.to_s) &&
                @settings[:list_status][@status.id.to_s].to_i == 1
              )
            )

            @check_projects = @settings[:list_project].has_key?(@project_id.to_s)
            @check_trackers = @settings[:list_tracker].has_key?(@tracker_id.to_s)
          end

          Rails.logger.info(
            "Checking 'time_entry': @check=#{@check.inspect}, @check_projects=#{@check_projects.inspect}, @check_trackers=#{@check_trackers.inspect}, hours=#{params[:time_entry][:hours].inspect}"
          )


          if @check &&
             @check_trackers &&
             @check_projects &&
             params[:time_entry][:hours].blank?

            flash[:error] = @settings[:required_msg]
            find_issue
            update_issue_from_params
            render(:action => 'edit') and return
          end

          super
        rescue
          super
        end
      end
    end
  end
end

