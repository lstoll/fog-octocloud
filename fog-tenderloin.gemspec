Gem::Specification.new do |s|
  s.name = %q{fog-tenderloin}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lincoln Stoll"]
  s.date = %q{2012-10-11}
  s.description = %q{Fog implementation for Tenderloin}
  s.email = ["lincoln@github.com"]
  s.extra_rdoc_files = [
     "README.md",
  ]
  s.files = %w[lib].map {|d| Dir.glob("#{d}/**/*")}.flatten + %w[README.md]
  s.homepage = %q{http://github.com/lstoll/fog-tenderloin}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Fog implementation for Tenderloin}
  # s.test_files = Dir.glob("spec/**/*")

  s.add_runtime_dependency "fog",  "~> 1.6"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "tenderloin", "~> 0.4.3"
end
