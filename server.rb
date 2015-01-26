require 'socket' 
                                   # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started

loop do                                             # Server runs forever
  client = server.accept                            # Wait for a client to connect. Accept returns a TCPSocket

  lines = []
  while (line = client.gets.chomp)   # Read the request and collect it until it's empty
    break if line.empty?
	lines << line
  end


  puts lines            

  filename = lines[0].gsub(/GET \//, '').gsub(/\ HTTP.*/, '')
	response_body = nil
	if File.exists?(filename)
	  response_body = File.read(filename)
	else
	  response_body = "File Not Found\n" 				# need to indicate end of the string with \n
	end                           						 # Output the full request to stdout

  client.puts(response_body)                       # Output the current time to the client
  client.close                                      # Disconnect from the client
end
