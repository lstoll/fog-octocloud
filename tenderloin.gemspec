Gem::Specification.new do |s|
  s.name = %q{tenderloin}
  s.version = "0.4.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lincoln Stoll"]
  s.date = %q{2013-01-04}
  s.description = %q{Tenderloin is a tool for building and distributing virtualized development environments using VMWare fusion. Also includes a fog driver to interact with these VMs}
  s.email = ["lstoll@me.com"]
  s.executables = ["loin"]
  s.extra_rdoc_files = [
    "LICENCE",
     "README.md"
  ]
  s.files = %w[lib bin script templates config].map {|d| Dir.glob("#{d}/**/*")}.flatten + %w[LICENCE README.md Version]
  s.homepage = %q{http://github.com/lstoll/tenderloin}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Tenderloin is a tool for building and distributing virtualized development environments using VMWare fusion.}
  s.test_files = Dir.glob("test/**/*")

  s.add_runtime_dependency "net-ssh",               ">= 2.0.19"
  s.add_runtime_dependency "net-scp",               ">= 1.0.2"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "archive-tar-minitar",   "= 0.5.2"
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "fog",  "~> 1.6"
end
