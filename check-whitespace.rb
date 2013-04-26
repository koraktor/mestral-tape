# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2013, Sebastian Staudt

puts 'Checking whitespace...'
puts git('diff-index --check --cached HEAD 2>&1')
$?.success? ? pass : fail
