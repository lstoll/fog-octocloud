# fog-octocloud

Implementation of Octocloud API for fog

## Usage

Let me tell you a story in irb.

```ruby
irb(main)> require 'fog-octocloud'
=> true
irb(main):002:0> oc = Fog::Compute.new(:provider => "Octocloud", :octocloud_url => 'http://localhost:5000', :octocloud_api_key => '21f0f666-0881-4038-a19e-a37accdcd74d')
=> #<Fog::Compute::Octocloud::Real:70272936306420>
irb(main)> oc.cubes.all
=>   <Fog::Compute::Octocloud::Cubes
    [
      <Fog::Compute::Octocloud::Cube
        id=1,
        name="precise64",
        image_urls={"esx"=>"http://localhost:8000/precise64.vmdk"},
        revision=1
      >
    ]
  >
irb(main)> oc.servers.all
=>   <Fog::Compute::Octocloud::Servers
    []
  >
irb(main)> svr = oc.servers.create({:type => "esx", :cube => "precise64", :memory => 512})
=>   <Fog::Compute::Octocloud::Server
    id=16,
    memory=512,
    name=nil,
    message=nil,
    expiry=nil,
    cube="precise64",
    mac=nil,
    type="esx",
    hypervisor_host=nil,
    running=nil,
    ip=nil
  >
irb(main)> svr.running?
=> nil
irb(main)> svr.reload
=>   <Fog::Compute::Octocloud::Server
    id=17,
    memory=512,
    name=nil,
    message=nil,
    expiry="2012-10-22T13:40:10+0200",
    cube="precise64",
    mac="00:0c:29:63:38:1a",
    type="esx",
    hypervisor_host="192.168.237.168",
    running=true,
    ip=nil
  >
irb(main)> svr.running?
=> true
irb(main)> svr.ip
=> nil
irb(main)> svr.reload
=>   <Fog::Compute::Octocloud::Server
    id=17,
    memory=512,
    name=nil,
    message=nil,
    expiry="2012-10-22T13:40:10+0200",
    cube="precise64",
    mac="00:0c:29:63:38:1a",
    type="esx",
    hypervisor_host="192.168.237.168",
    running=true,
    ip="192.168.237.250"
  >
irb(main)> svr.ip
=> "192.168.237.250"
irb(main)> svr.destroy
=> true
irb(main)> oc.servers.all
=>   <Fog::Compute::Octocloud::Servers
    []
  >
irb(main)> oc.cubes.create({:name => "test-cube", :url => "http://test/test.vmdk"})
=>   <Fog::Compute::Octocloud::Cube
    id=25,
    name="test-cube",
    image_urls={:esx=>"http://test/test.vmdk"},
    revision=nil
  >
irb(main)> oc.cubes.all
=>   <Fog::Compute::Octocloud::Cubes
    [
      <Fog::Compute::Octocloud::Cube
        id=1,
        name="precise64",
        image_urls={"esx"=>"http://localhost:8000/precise64.vmdk"},
        revision=1
      >,
      <Fog::Compute::Octocloud::Cube
        id=25,
        name="test-cube",
        image_urls={"esx"=>"http://test/test.vmdk"},
        revision=1
      >
    ]
  >
irb(main):025:0> oc.cubes.last.destroy
=> true
```


## Licence

Copyright (C) 2012 Github, Inc. All Rights Reserved
