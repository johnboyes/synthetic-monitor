require 'rest-client'

def retryable &block
  tries = 0
  begin
    yield
  rescue
    tries += 1
    sleep 1
    retry if tries < 10
  end
end

def assert_hashes_equal expected, actual
  assert_equal [], HashDiff.diff(expected, actual)
end


module RunscopeHelper

  BUCKET_KEY = "32dq2c18qk24"
  AUTHORIZATION_HEADER = {:Authorization => 'Bearer 05d16442-31df-4f23-947d-9a5eec4f0525'}

  def assert_success_notification_sent
    assert_equal 1, success_notifications.size
    success_notification = get_json message_url(success_notifications.first['uuid'])
    body = JSON.parse success_notification["data"]["request"]["body"]
    assert_equal("all monitoring tests passed", body["data"])
  end

  def assert_no_success_notification_sent
    assert_empty success_notifications
  end

  def get_json url
    JSON.parse( RestClient.get(url, AUTHORIZATION_HEADER) )
  end

  def bucket_url
    "https://api.runscope.com/buckets/#{BUCKET_KEY}"
  end

  def message_url uuid
    "#{bucket_url}/messages/#{uuid}"
  end

  def success_notifications
    runscope_messages = get_json "#{bucket_url}/stream"
    assert_equal "success", runscope_messages["meta"]["status"]
    runscope_messages["data"]
  end

  def delete_message message
    RestClient.delete message_url(message['uuid']), AUTHORIZATION_HEADER
  end

  def delete_all_success_notifications
    success_notifications.each { | message | delete_message message }
  end

end
