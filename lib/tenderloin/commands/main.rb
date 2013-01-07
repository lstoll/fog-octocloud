# This is the entry point that contains the global options.

class LoinCLI < Clamp::Command

  option "--flavour", "FLAVOUR", "ice-cream flavour"

  subcommand "init", "Initialize the repository" do
    option "--flavour2", "FLAVOUR2", "ice-cream flavour2"
    def execute
      # ...
      puts "flav #{flavour}"
      puts "flav2 #{flavour2}"
    end

  end

end



class LoinCLI < Clamp::Command
  subcommand "no", "no what?" do
    def execute
      puts "hmmm #{flavour}"
    end
  end
end
