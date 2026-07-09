require 'redmine'
require File.dirname(__FILE__) + '/lib/SpentTimeRequired.rb'

# require 'dispatcher'
ActiveSupport::Reloader.to_prepare do
#ActionDispatch::Callbacks.to_prepare :SpentTimeRequired do
     IssuesController.send(:include, SpentTimeRequired::Patches::IssuesControllerPatch)
end

Redmine::Plugin.register :spent_time_required do
  name 'Spent Time Required plugin'
  author 'Rodolfo Stangherlin'
  description 'This plugin makes the "Time Spent" field mandatory.'
  version '0.2.0'
  url 'https://github.com/nautics889/redmine_spent_time_required/tree/master/spent_time_required'
  author_url 'https://gist.github.com/nautics889/452377b90a1f06c7cb4120a6fb51b24c'

  settings(:default => {
        :required_msg => 'Spent time is required now. Do not forget it!',
        :list_status => {1=>false},
        :list_tracker => {1=>false},
        :list_project => {1=>false},
        :all_closed_statuses => true,
        :all_statuses => false,
  }, :partial => 'settings/conf_settings')
end
