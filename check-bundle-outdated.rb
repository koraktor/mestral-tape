# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2013, Sebastian Staudt

puts 'Checking bundler dependencies...'
puts `bundle outdated 2>&1`
$?.success? ? pass : fail
