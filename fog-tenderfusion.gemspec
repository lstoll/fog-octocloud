Gem::Specification.new do |s|
  s.name = %q{fog-tenderfusion}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lincoln Stoll"]
  s.date = %q{2013-01-15}
  s.description = %q{fog-tenderfuison is a fog driver that lets you create a local, VMWare Fusion driven 'cloud'}
  s.email = ["lstoll@me.com"]
  s.executables = []
  s.extra_rdoc_files = [
    "LICENCE",
     "README.md"
  ]
  s.files = %w[lib/fog].map {|d| Dir.glob("#{d}/**/*")}.flatten + %w[LICENCE README.md lib/fog-tenderfusion.rb]
  s.homepage = %q{http://github.com/lstoll/tenderloin}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = s.description.dup
  s.test_files = Dir.glob("spec/**/*")

  s.add_runtime_dependency "net-ssh",               ">= 2.0.19"
  s.add_runtime_dependency "net-scp",               ">= 1.0.2"
  s.add_runtime_dependency "archive-tar-minitar",   "= 0.5.2"
  s.add_runtime_dependency "fog",                   "~> 1.6"
end
