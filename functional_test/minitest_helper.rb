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

def assert_notification_sent_to_slack
  assert_hashes_equal @expected_slack_notification_request_body, request_body_sent_to_slack
end

def assert_no_notification_sent_to_slack
  assert_nil request_body_sent_to_slack
end

def request_body_sent_to_slack
  request_body_for_request_id 1
end

def assert_success_notification_sent
  assert_equal("all monitoring tests passed", success_request_body_sent["data"])
end

def success_notifications_post_url
  "http://localhost:7001/responses/success"
end

def assert_no_success_notification_sent
  assert_nil success_request_body_sent
end

def success_request_body_sent
  request_body_for_request_id 2
end

def request_body_for_request_id(request_id)
  retryable { JSON.parse(@mirage.requests(request_id).body) }
end
