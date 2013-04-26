# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2013, Sebastian Staudt

require 'tmpdir'

puts 'Checking syntax of modified Ruby files...'

ruby_files = git('diff-index --cached --name-only -z HEAD').split("\0").
  select { |file| File.extname(file) == '.rb' || File.extname(file) == '.rbw' }

Dir.mktmpdir do |tmpdir|
  ruby_files.each do |file|
    git("checkout-index --prefix=#{tmpdir}/ -z #{file}")
    $stdout << " - Checking #{file}: "
    temp_file = File.expand_path file, tmpdir
    puts `ruby -c #{temp_file} 2>&1`.sub(/^#{temp_file}:/, 'Line ')
    fail unless $?.success?
  end
end
