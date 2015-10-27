## web-Setup
node /^web-i-.*\.web.tradetracker.net.in/ {
  include basenode
  include pg::pgpool ## Installing psql (client version 9.2)
  include mongo::client ## Installing mongo client
  include symphony
}
