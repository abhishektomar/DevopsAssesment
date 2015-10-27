## pgpool-Setup
node /^pgpool-i-.*\.pgpool.tradetracker.net.in/ {
  include basenode
  include pg
  include pg::pgpool
}
