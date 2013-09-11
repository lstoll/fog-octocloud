notification :terminal_notifier

guard :test do
  watch(%r{^lib/fog/octocloud/requests/(.+)\.rb$})     { |m| "test/requests/#{m[1]}_test.rb" }
  watch(%r{^lib/fog/octocloud/models/(.+)\.rb$}) { |m| "test/models/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch('test/test_helper.rb')  { "test" }
end
