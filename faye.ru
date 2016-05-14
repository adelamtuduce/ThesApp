require 'faye'
faye_server = Faye::RackAdapter.new(:mount => '/faye')
run faye_server