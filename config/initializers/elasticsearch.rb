# config/initializers/elasticsearch.rb

# Configure the Elasticsearch client
Elasticsearch::Model.client = Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200')

client = Elasticsearch::Model.client

# Perform operations
puts client.ping
puts client.search(q: 'test')