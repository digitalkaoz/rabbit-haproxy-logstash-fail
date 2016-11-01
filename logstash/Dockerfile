FROM logstash:5

RUN sed -i 's/https/http/' /usr/share/logstash/Gemfile
RUN logstash-plugin update --no-verify logstash-input-rabbitmq