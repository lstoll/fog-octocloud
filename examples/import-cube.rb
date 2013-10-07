require 'fog-octocloud'

octoc = Fog::Compute.new( :provider => 'octocloud' )

# Importing a cube to Octocloud/Fusion/Workstation
#
# The destination depends on the credentials given.
# If ~/.fog contains Octocloud credentials or the credentials
# are given to the constructor above, fog-octocloud will import
# the cube to Octocloud, otherwise to local Fusion/Workstation
cube = octoc.cubes.create :name =>   'test-cube',
                          :source => File.expand_path('my.ova')

# create accepts .ova,.box and .vmdk sources and they can be
# local or remote (URL).
cube = octoc.cubes.create :name =>   'test-cube',
                          :source => 'http://myserver.com/my.ova'

# Importing VMDK to local Fusion/Workstation is a special case.
# It will generate a VMX file for you and you can add some extra
# attributes to specify guest attributes.
cube = octoc.cubes.create :name =>   'test-cube',
                          :source => 'my.vmdk',
                          :guest_os => 'ubuntu-64', #defaults to otherlinux
                          :memory => 1024,
                          :cpus => 4
