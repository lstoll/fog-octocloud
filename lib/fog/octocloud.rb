require 'fog/core'

module Fog
  module Octocloud

    extend Fog::Provider

    # service(:compute, 'octocloud/compute', 'Compute')
    service(:compute, 'Compute')

  end
end
