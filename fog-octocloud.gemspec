Gem::Specification.new do |s|
  s.name = %q{fog-octocloud}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lincoln Stoll"]
  s.date = %q{2012-10-11}
  s.description = %q{Some kind of cloud. Supports local VMWare Fusion VMs, as well as octocloud server}
  s.email = ["lincoln@github.com"]
  s.extra_rdoc_files = [
                        "README.md"
                        "LICENCE",
  ]
  s.files = %w[lib].map {|d| Dir.glob("#{d}/**/*")}.flatten + %w[README.md]
  s.homepage = %q{http://github.com/lstoll/octocloud-fog}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Implementation of Octocloud API for Fog}

  s.test_files = Dir.glob("spec/**/*")

  s.add_runtime_dependency "fog",  "~> 1.5"
  s.add_runtime_dependency "json", "~> 1.7"
  s.add_runtime_dependency "net-ssh",               ">= 2.0.19"
  s.add_runtime_dependency "net-scp",               ">= 1.0.2"
  s.add_runtime_dependency "archive-tar-minitar",   "= 0.5.2"

end
