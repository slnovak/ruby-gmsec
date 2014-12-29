## GMSEC for Ruby ##

This is a Ruby library that wraps the [GMSEC API](http://gmsec.gsfc.nasa.gov/) in a
Ruby-friendly way. This makes it easy to quickly develop applications that can be deployed
in a ground system environment that leverages the various software libraries in the Ruby
community.

## Installation ##

You will need to compile and install GMSEC 3.6 according to GMSEC documentation. Ensure that
the GMSEC and supporting libraries (Bolt, MBServer, etc) are available in a standard
library location such as `/usr/local/lib`. If on Windows, make sure that your `PATH` variable
includes the location of where the GMSEC library exists.

After that, simply run: `gem install gmsec` to install this gem!

## Example Usage ##

```ruby
require 'gmsec'

# Create a connection by passing configuration options.
connection = GMSEC::Connection.new(connectiontype: :gmsec_mb)

# Connect based on connection defaults, i.e., localhost.
connection.connect

connection.connected? # Return true

connection.subscribe("TEST.*") do |message|
  # Print the message
  puts message.to_s
end

# Start auto dispatching so that the above subscription will be automatically kicked off
# when a message is received.
connection.start_auto_dispatch

# Create a new message using connection defaults.
message = connection.new_message

# We can add fields to messages using bracket notation:
message[:foo] = :bar

# We can append hashes to a message, creating multiple fields at once:
message << {answer: 42, baz: true}

# Or we can explicitly create a GMSEC Field object where we specify the data type:
message << GMSEC::Field.new(:bar, "x", type: :char)

message.subject = "TEST.FOO"

# Publish the message.
connection.publish(message)

# We should see:
#
# +---------------+------------------------------------------+
# |                         TEST.FOO                         |
# +---------------+------------------------------------------+
# | CONNECTION-ID | 2                                        |
# | MW-INFO       | gmsec_mb: localhost                      |
# | NODE          | xxxxx_local                              |
# | PROCESS-ID    | 64047                                    |
# | PUBLISH-TIME  | 2014-363-00:53:45.604                    |
# | UNIQUE-ID     | GMSEC_XXXXX_LOCAL_54A0A61980A4_64047_2_1 |
# | USER-NAME     | user                                     |
# | answer        | 42                                       |
# | bar           | x                                        |
# | baz           | true                                     |
# | foo           | bar                                      |
# +---------------+------------------------------------------+

# We can also publish messages easily without having to create `Message` instances:
connection.publish({foo: :bar, answer: 42, baz: true}, subject: "TEST.BAZ")
```
