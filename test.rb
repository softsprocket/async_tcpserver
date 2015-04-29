#!/usr/bin/ruby

require "async_tcpserver"

server = AsyncTCPServer.new 8000, 10

server.on :error, Proc.new { |error|
	STDERR.puts "Error: #{error}"
	server.close
}

server.on :connect, Proc.new { |client| 
	client.on :data, Proc.new { |data|
		client.puts data
	}
}

server.accept false

gets

server.close

