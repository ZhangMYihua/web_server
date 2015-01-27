require 'socket' 
                                   # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started


def read_request(client)

  lines = []

  while (line = client.gets.chomp)  				# Read the request and collect it until it's empty
    break if line.empty?
	lines << line
  end
   return lines 
end

def file_type(filename)
  		if filename =~ /.css/
	  		content_type = "text/css"
	  	elsif filename =~ /.html/
	  		content_type = "text/html"
	  	else 
	  		content_type = "text/plain"
	  	end
end 

def parse_filename(request)
		parsed_file_name = request[0].gsub(/GET \//, '').gsub(/\ HTTP.*/, '')
		return parsed_file_name
end

loop do
		
	client = server.accept

	request = read_request(client)

  puts request         

  filename = parse_filename(request)
	

	response_body = nil
	headers = []

	
	if File.exists?(filename)
	  response_body = File.read(filename)
	  	headers << "HTTP/1.1 200 OK"
	  	content_type = file_type(filename)
		headers << "Content type: #{content_type}"
	else
	  response_body = "File Not Found\n" 
	  	headers << "HTTP/1.1 404 Not Found"
	  	headers << "Content-Type: text/plain" 									# need to indicate end of the string with \n
	end                           						 # Output the full request to stdout
		headers << "Content-Length: #{response_body.length}"
		headers << "Connection: close"
		headers = headers.join("\r\n")

	response = [headers, response_body].join("\r\n\r\n")


  client.puts(response)
  puts headers
                         # Output the current time to the client
  client.close                                      # Disconnect from the client
end
