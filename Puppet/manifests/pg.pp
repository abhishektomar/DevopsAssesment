## pg-Setup
node /^pg-i-.*\.pg.tradetracker.net.in/ {
  include basenode
  include pg
  include pg::server
}
