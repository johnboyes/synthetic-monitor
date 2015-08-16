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
