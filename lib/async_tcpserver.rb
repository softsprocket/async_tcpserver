require 'ready_pool'
require 'async_emitter'
require 'async_tcpsocket'
require 'thread'

################################################################################################
# Asynchronous TCP Server implementation
#
# Wraps TCPServer. The server emits,
# :connect to signal a new connection - a AsyncTCPSocket is passed to the Proc,
# :error to signal errors.
#
# If the accept method is called with the argument false it is non-blocking, otherwise it blocks;
# the example below blocks on the gets call as an example of a non-blocking accept.
#
# ==Example
# 
#    require "./lib/async_tcpserver"
#    
#    server = AsyncTCPServer.new 8000, 10
#    
#    server.on :error, Proc.new { |error|
#        STDERR.puts "Error: #{error}"
#        server.close
#    }
#    
#    server.on :connect, Proc.new { |client| 
#        client.on :data, Proc.new { |data|
#            client.puts data
#        }
#    }
#    
#    server.accept false
#    
#    gets
#
#    server.close
#
# @author Greg Martin
################################################################################################## 
class AsyncTCPServer < AsyncEmitter

	#########################################################################################
	# constructor
	#
	# @param hostname [String] optional host to bind to
	# @param port [FixedNum] port to bind to
	# @param num_threads [FixedNum] initial number of threads
	########################################################################################
	def initialize (*hostname, port, num_threads)
		super()

		@listen_thread = nil
		@pool = ReadyPool.new num_threads, lambda { |client| thread_procedure client }
	
		begin		
			if (hostname.length == 0)
				@server = TCPServer.new port
			else
				@server = TCPServer.new hostname[0], port
			end
		rescue Exception => e
			emit :error, e
		end

	end


	#########################################################################################
	# listen for connection requests
	#
	# @param blocking [Boolean] optional if set to false accept is non-blocking
	########################################################################################
	def accept (blocking=true)
		if !blocking
			@listen_thread = Thread.new do
				loop do
					client = @server.accept
					@pool.start client
				end
			end
		else
			loop do
				client = @server.accept
				@pool.start client
			end
		end	
	end	

	#########################################################################################
	# close server socket
	########################################################################################
	def close
		@server.close
		if @listen_thread != nil
			Thread.kill @listen_thread
		end
	end

	protected
	def thread_procedure (client)
		tcp_client = AsyncTCPSocket.new client
		emit :connect, tcp_client
	end

end

