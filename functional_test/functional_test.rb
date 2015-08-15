require 'minitest/autorun'
require 'minitest/spec'
require 'synthetic_monitor'
require 'mirage/client'
require 'json'
require 'hashdiff'

class FunctionalTest < Minitest::Test

  def setup
    ENV.store 'SLACK_WEBHOOK', 'http://localhost:7001/responses/slack'
    Mirage.start
    @mirage = Mirage::Client.new
    @mirage.put('slack', 'Notification received on Slack') { http_method 'POST' }
    @expected_slack_notification_request_body = {"attachments"=> [{"fallback"=>"ALERT: 1 test failed", "color"=>"danger", "title"=>"ALERT: 1 test failed", "fields"=> [{"title"=>"example example of a test which will fail, triggering a notification on Slack", "value"=>"\n\nexpected: 500\n     got: 200\n\n(compared using ==)\n\n# ./spec/example_spec.rb:19\n==================================================="}]}]}
  end

  def retryable &block
    yield rescue retry
  end

  def assert_hashes_equal(expected, actual)
    assert_equal [], HashDiff.diff(expected, actual)
  end

  def assert_notification_sent_to_slack
    assert_hashes_equal @expected_slack_notification_request_body, JSON.parse(@mirage.requests(1).body)
  end

  def test_one_test_fails_and_notifies_on_slack
    @monitor_thread = Thread.new { SyntheticMonitor.new.monitor ENV['SLACK_WEBHOOK'] }
    retryable { assert_notification_sent_to_slack }
  end

  def teardown
    @monitor_thread.exit
    @mirage.clear
    Mirage.stop
  end

end
