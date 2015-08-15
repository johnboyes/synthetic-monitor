# functional test

Tests in this directory functionally test the application - they are not part of the gem itself.

Run the functional test suite:

```ruby
bundle exec rake test
```

The tests are written using [minitest](http://docs.seattlerb.org/minitest/) so as not to interfere with the RSpec [monitoring specs](../spec/README.md) which perform the actual monitoring in the functional tests.