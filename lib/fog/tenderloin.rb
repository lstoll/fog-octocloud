require 'fog/core'

module Fog
  module Tenderloin

    extend Fog::Provider

    service(:compute, 'tenderloin/compute', 'Compute')

  end
end

# Monkey patch out provider lookup
module Fog
  module Compute
    class << self
      alias_method :pre_tenderloin_new, :new

      def new(attributes)
        dup_attr = attributes.dup # prevent delete from having side effects
        provider = dup_attr.delete(:provider).to_s.downcase.to_sym
        if provider == :tenderloin
          require 'fog/tenderloin/compute'
          Fog::Compute::Tenderloin.new(dup_attr)
        else
          pre_tenderloin_new(attributes)
        end
      end
    end
  end
end
