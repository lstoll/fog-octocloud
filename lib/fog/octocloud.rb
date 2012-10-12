require 'fog/core'

module Fog
  module Octocloud

    extend Fog::Provider

    service(:compute, 'octocloud/compute', 'Compute')

  end
end

# Monkey patch out provider lookup
module Fog
  module Compute
    class << self
      alias_method :super_new, :new

      def new(attributes)
        dup_attr = attributes.dup # prevent delete from having side effects
        provider = dup_attr.delete(:provider).to_s.downcase.to_sym
        if provider == :octocloud
          require 'fog/octocloud/compute'
          Fog::Compute::Octocloud.new(dup_attr)
        else
          super_new(attributes)
        end
      end
    end
  end
end
