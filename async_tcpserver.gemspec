Gem::Specification.new do |s|
	s.name        = 'async_tcpserver'
	s.version     = '1.0.0'
	s.date        = '2015-04-29'
	s.summary     = "AsyncTCPServer"
	s.description = "An asyncronous tcp server for ruby"
	s.authors     = ["Greg Martin"]
	s.email       = 'greg@softsprocket.com'
	s.files       = ["lib/async_tcpserver.rb"]
	s.homepage    = 'http://rubygems.org/gems/async_tcpserver.rb'
	s.license     = 'MIT'
	s.add_runtime_dependency "async_emitter", '~> 1.1', '>= 1.1.1'
	s.add_runtime_dependency "ready_pool", '~> 1.1', '>= 1.1.0'
	s.add_runtime_dependency "async_tcpsocket", '~> 1.0', '>= 1.0.0'
end

