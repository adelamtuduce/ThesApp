require 'faye'
faye_server = Faye::RackAdapter.new(:mount => '/faye', :engine => { port: '9296' })
Faye::WebSocket.load_adapter('thin')
run faye_server