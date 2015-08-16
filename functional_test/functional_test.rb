require 'minitest/autorun'
require 'minitest/spec'
require 'synthetic_monitor'
require 'mirage/client'
require 'json'
require 'hashdiff'
require 'minitest_helper'

class FunctionalTest < Minitest::Test

  include RunscopeHelper

  def setup
    ENV.store 'SLACK_WEBHOOK', 'http://localhost:7001/responses/slack'
    delete_all_success_notifications
    Mirage.start
    @mirage = Mirage::Client.new
    @mirage.put('slack', 'Notification received on Slack') { http_method 'POST' }
    @expected_slack_notification_request_body = {"attachments"=> [{"fallback"=>"ALERT: 1 test failed", "color"=>"danger", "title"=>"ALERT: 1 test failed", "fields"=> [{"title"=>"failing test example example of a test which will fail, triggering a notification on Slack", "value"=>"\n\nexpected: 500\n     got: 200\n\n(compared using ==)\n\n# ./spec/failure_spec.rb:13\n==================================================="}]}]}
  end

  def assert_notification_sent_to_slack
    assert_hashes_equal @expected_slack_notification_request_body, request_body_sent_to_slack
  end

  def assert_no_notification_sent_to_slack
    assert_nil request_body_sent_to_slack
  end

  def request_body_sent_to_slack
    retryable { JSON.parse(@mirage.requests(1).body) }
  end

  def test_run_success_spec
    @monitor_thread = Thread.new {
      monitor = SyntheticMonitor.new(success_notifications_url: success_notifications_post_url)
      monitor.monitor 'spec/success_spec.rb', ENV['SLACK_WEBHOOK']
    }
    assert_no_notification_sent_to_slack
  end

  def teardown
    @monitor_thread.exit
    @mirage.clear
    Mirage.stop
    delete_all_success_notifications
  end

end
