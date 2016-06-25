require 'faye'
faye_server = Faye::RackAdapter.new(:mount => '/faye')
Faye::WebSocket.load_adapter('thin')
run faye_server