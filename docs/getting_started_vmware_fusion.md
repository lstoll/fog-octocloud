# VMware Fusion fog-octocloud driver

In addition to VMware ESX(i), fog-octocloud can be used to
provision local VMs using VMware Fusion as the backend, which is 
quite convenient for working/testing enterprise cookbooks while offline.

The first thing we need is a local Cube (VM template) to work with.
fog-octocloud can import OVA and regular OctoCloud boxes (.box files) and
OVA exports from an existing Fusion VM can be created using VMware Fusion's
ovftool.

## Creating a Cube (VM template) from local OVA

OVA files are basically gunzipped tarballs containing a VMDK file, a manifest
and a VMX file:

```sh
$ tar xzvf tinycore-477.ova
x tinycore-477.ovf
x tinycore-477.mf
x tinycore-477-disk1.vmdk
```

We can easily create one using the ovftool command included with VMware
Fusion located at:

    /Applications/VMware Fusion.app/Contents/Library/VMware OVF Tool/ovftool

Assuming your Fusion VMs are stored in the ~/Documents folder, to create an 
OVA from an existing VM:

```sh
cd ~/Documents/Virtual\ Machines.localized
ovftool -tt=OVA tinycore-477.vmwarevm/tinycore-477.vmx ~/tmp/tinycore-477.ova
```

Where ~/tmp/tinycore-477.ova is the target path where we want to store the OVA
file.

To create a new Cube from an OVA:

```ruby
require 'pp'
require 'fog'
require 'fog-octocloud'

# Create a compute service instance
octoc = Fog::Compute.new( :provider => 'octocloud' )

# Create the Cube (converting the OVA to a Cube)
#
# This will basically use ovftool to covert the OVA
# to a VM template that we can re-use later.
# See [lib/fog/octocloud/request/compute/convert_cube.rb](https://github.com/lstoll/fog-octocloud/blob/master/lib/fog/octocloud/requests/compute/convert_cube.rb)
# 
cube = octoc.cubes.create :name => 'test-cube', 
                          :source => File.expand_path('~/tmp/tinycore-477.ova')
```

After creating the cube, a new ~/.octocloud/boxes/test-cube will be created with
the required VM template files inside:

```sh
$ ls ~/.octocloud/boxes/test-cube/
vmwarebox-disk1.vmdk vmwarebox.vmx
```

We can list the cubes available using fog-octocloud:

```ruby
pp octoc.cubes
# This will output:
#
# [WARNING] loading OctoCloud remote credentials failed, resorting to local Fusion driver
# [<Fog::Compute::Octocloud::LocalCube
#     name="test-cube",
#     source=nil,
#     md5="f55b468fb1b9f13fdc076e53c0e4ad9e"
# >]
```

## Creating a new server (VM) from an existing cube

Now that we have a local cube, we can create a new Fusion VM:

```ruby
# cube is the test-cube instance we previously created from the OVA
#
server = octoc.servers.create :name => 'test-server',
                              :cube => cube
server.start
server.wait_for { running? }

pp octoc.servers
```

And destroy it afterwards:

```ruby
server.destroy
```
