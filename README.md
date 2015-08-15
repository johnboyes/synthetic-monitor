# synthetic-monitor
Simple website synthetic monitoring gem.

Example app which uses this gem: [example-synthetic-monitor](https://github.com/johnboyes/example-synthetic-monitor)

The **[example application](https://github.com/johnboyes/example-synthetic-monitor) is deployable on Heroku** which makes it **very quick to get production monitoring up and running**, and the monitoring is specified in **plain old [RSpec](http://rspec.info/) tests**, which means that your monitoring is much more **easily customised** to your needs than most solutions.

Run all the specs in the ['spec' directory](spec), every 5 minutes, and **notify any failures on a [Slack](https://slack.com/) channel or group** (with [SMS notifications coming soon](https://github.com/johnboyes/synthetic-monitor/issues/1)):

```ruby
SyntheticMonitor.new.monitor ENV['SLACK_WEBHOOK_URL']
```
([jump to this code snippet](https://github.com/johnboyes/example-synthetic-monitor/blob/a8ede4c99801170ffa22faf575854adf091d574a/example_synthetic_monitor.rb#L1-L3))


Alternatively you can have individual spec files notify an individual Slack channel or group:

```ruby
spec_slack_pairs = {
  'spec/a_spec.rb' => ENV['A_SlACK_WEBHOOK_URL'], 
  'spec/another_spec.rb' => ENV['A_DIFFERENT_SLACK_WEBHOOK_URL'],
  'spec/a_third_spec.rb' => ENV['A_THIRD_SLACK_WEBHOOK_URL'],
}

SyntheticMonitor.new.monitor_on_varying_slack_channels spec_slack_pairs
```

The monitoring frequency is customisable:

```ruby
SyntheticMonitor.new(frequency_in_minutes: 10).monitor
```

An example spec:

```ruby
scenario "monitor example.com" do
  @session.visit 'https://www.example.com'
  expect(@session).to have_content("This domain is established to be used for illustrative examples in documents.")
  expect(@session.status_code).to eq(200)
end
```
([jump to this code snippet](https://github.com/johnboyes/example-synthetic-monitor/blob/3543655f8d5c09295d1ed2ec456f0d731bec086c/spec/example_spec.rb#L13-L17))

## Running the [functional tests](functional_test)

```ruby
bundle exec rake test
```

## Coming soon
- [SMS notifications](https://github.com/johnboyes/synthetic-monitor/issues/1)
- [Attach a screenshot to each notification](https://github.com/johnboyes/synthetic-monitor/issues/2)
