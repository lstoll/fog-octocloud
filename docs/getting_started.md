# Getting started: the OctoCloud(TM) compute service

## Connecting, retrieving and managing server objects

Before we start, I guess it will be useful to the reader to know
that Fog servers are 'instances|VMs' in OctoCloud's parlance. 
'Server' is the Fog way to name VMs, and we have
respected that in the OctoCloud's Fog provider.

First, create a connection to the host:

```ruby
require 'fog'

octoc = Fog::Compute.new({
  :provider => 'octocloud',
  :octocloud_url =>     'https://my.foo.octocloud.com', # OctoCloud URL here
  :octocloud_api_key => 'API_KEY_HERE'                  # your client key here
})
```

## Listing servers

Listing servers and some of the available attributes:

```ruby
octoc.servers.each do |server|
  # remember, servers are instances 
  puts server.id
  puts server.name
  puts server.running
  puts server.public_ip_address
  puts server.cube
  puts server.private_key_file
  puts server.ready?
  puts server.sshable?
  puts server.ip
end
```

## Server creation and life-cycle management

We need to find the cube (VM template) we'll be using first:

```ruby
cube = octoc.cubes.find { |c| c.name == 'uber-hubber-cube' }
```

Creating a new server (instance):

```ruby
server = octoc.servers.create :name => 'foobar',
                              :memory => '1024', # FIXME, I assume MB, but need 2 double check
                              :type => 'esx',
                              :cube => cube.name
```

The server is automatically started after that.

We didn't pay much attention when choosing the cube, but you can easily list 
them too, and then decide:

```ruby
octoc.cubes.each do |cube|
  cube.name
  cube.source
  cube.md5
end
```

TO BE CONTINUED...
