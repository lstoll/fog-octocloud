require 'fog/core'

module Fog
  module Tenderfusion

    extend Fog::Provider

    service(:compute, 'tenderfusion/compute', 'Compute')

  end
end

# Monkey patch out provider lookup
module Fog
  module Compute
    class << self
      alias_method :pre_tenderfusion_new, :new

      def new(attributes)
        dup_attr = attributes.dup # prevent delete from having side effects
        provider = dup_attr.delete(:provider).to_s.downcase.to_sym
        if provider == :tenderfusion
          require 'fog/tenderfusion/compute'
          Fog::Compute::Tenderfusion.new(dup_attr)
        else
          pre_tenderfusion_new(attributes)
        end
      end
    end
  end
end
