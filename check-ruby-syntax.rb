# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2013, Sebastian Staudt

require 'tmpdir'

puts 'Checking syntax of modified Ruby files...'

diff_index = git('diff-index --cached --name-status -z HEAD').split("\0")
file_status = Hash[*diff_index.reverse]
ruby_files = Hash[file_status.select do |file, status|
  %w{A M}.include?(status) &&
  %w{.rb .rbw}.include?(File.extname(file))
end]

Dir.mktmpdir do |tmpdir|
  ruby_files.keys.each do |file|
    git("checkout-index --prefix=#{tmpdir}/ -z #{file}")
    $stdout << " - Checking #{file}: "
    temp_file = File.expand_path file, tmpdir
    puts `ruby -c #{temp_file} 2>&1`.sub(/^#{temp_file}:/, 'Line ')
    fail unless $?.success?
  end
end
