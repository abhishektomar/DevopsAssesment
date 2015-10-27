## Mongo-Setup
node /^mongo-i-.*\.mongo.tradetracker.net.in/ {
  include basenode
  include mongo::server
}
