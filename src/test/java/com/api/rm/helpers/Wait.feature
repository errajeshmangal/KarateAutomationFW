Feature: Wait feature

@wait
Scenario: Static time period to wait for some time

And def sleep = function(millis){ java.lang.Thread.sleep(millis) }