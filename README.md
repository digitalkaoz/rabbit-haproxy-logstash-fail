# The Problem

if rabbit is killed and restarted, the logstash `rabbitmq-plugin` doesnt reestablish the connection.

## Reproduce

```bash
$ docker-compose up
```

wait until `logstash_1` says `rabbit says: bar`

now kill the rabbit node (probably in another terminal)

```bash
$ docker-compose kill rabbit
$ docker-compose start rabbit
$ docker-compose restart producer
```

when rabbit is up again, notice that logstash doesnt receive messages but the (restarted) producer generates such messages again.

when i restart logstash again it restarts to consume.

the last message from logstash was:

```
logstash_1  | {
    :timestamp=>"2016-10-25T10:32:06.788000+0000",
    :message=>"An unexpected error occurred!",
    :error=>com.rabbitmq.client.AlreadyClosedException: connection is already closed due to connection error;
        cause: java.io.EOFException,
        :class=>"Java::ComRabbitmqClient::AlreadyClosedException",
        :backtrace=>[
            "com.rabbitmq.client.impl.AMQChannel.ensureIsOpen(com/rabbitmq/client/impl/AMQChannel.java:195)",
            "com.rabbitmq.client.impl.AMQChannel.rpc(com/rabbitmq/client/impl/AMQChannel.java:241)",
            "com.rabbitmq.client.impl.ChannelN.basicCancel(com/rabbitmq/client/impl/ChannelN.java:1127)",
            "java.lang.reflect.Method.invoke(java/lang/reflect/Method.java:498)",
            "RUBY.method_missing(/opt/logstash/vendor/bundle/jruby/1.9/gems/march_hare-2.15.0-java/lib/march_hare/channel.rb:874)",
            "RUBY.shutdown_consumer(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-input-rabbitmq-4.1.0/lib/logstash/inputs/rabbitmq.rb:279)",
            "RUBY.stop(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-input-rabbitmq-4.1.0/lib/logstash/inputs/rabbitmq.rb:273)",
            "RUBY.do_stop(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-core-2.4.0-java/lib/logstash/inputs/base.rb:83)",
            "org.jruby.RubyArray.each(org/jruby/RubyArray.java:1613)", "RUBY.shutdown(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-core-2.4.0-java/lib/logstash/pipeline.rb:385)",
            "RUBY.stop_pipeline(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-core-2.4.0-java/lib/logstash/agent.rb:413)",
            "RUBY.shutdown_pipelines(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-core-2.4.0-java/lib/logstash/agent.rb:406)",
            "org.jruby.RubyHash.each(org/jruby/RubyHash.java:1342)", "RUBY.shutdown_pipelines(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-core-2.4.0-java/lib/logstash/agent.rb:406)",
            "RUBY.shutdown(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-core-2.4.0-java/lib/logstash/agent.rb:402)",
            "RUBY.execute(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-core-2.4.0-java/lib/logstash/agent.rb:233)",
            "RUBY.run(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-core-2.4.0-java/lib/logstash/runner.rb:94)",
            "org.jruby.RubyProc.call(org/jruby/RubyProc.java:281)", "RUBY.run(/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-core-2.4.0-java/lib/logstash/runner.rb:99)",
            "org.jruby.RubyProc.call(org/jruby/RubyProc.java:281)", "RUBY.initialize(/opt/logstash/vendor/bundle/jruby/1.9/gems/stud-0.0.22/lib/stud/task.rb:24)",
            "java.lang.Thread.run(java/lang/Thread.java:745)"],
        :level=>:warn}
```
