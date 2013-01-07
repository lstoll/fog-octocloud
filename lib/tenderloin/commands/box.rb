module Tenderloin
  class CLI < Clamp::Command
    subcommand "box", "Manage cubes. Works in the context of a found config/environment" do
      # def execute
      # end
      subcommand "add", "Add a cube" do
        parameter "NAME", "Name of box"
        parameter "SOURCE", "URL/Path to box"
        def execute
          load_env!
          logger.info "Adding box"
          Env.compute.cubes.create(:name => name, :source => source)
          logger.info "#{name} added"
        end
      end

      subcommand "list", "List cubes" do
        def execute
          load_env!
          Env.compute.cubes.all.each do |cube|
            puts cube.name
          end
        end
      end

      subcommand "delete", "Delete a cube" do
        parameter "NAME", "Name of box"
        def execute
          load_env!
          if cube = Env.compute.cubes.get(name)
            logger.info "Removing cube #{name}"
            cube.destroy
          else
            logger.error "Cube #{name} not found"
          end
        end
      end

    end
  end
end
