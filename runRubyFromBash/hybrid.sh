#!/usr/bin/env sh
echo "This is bash !"


# here, we use the "heredoc" syntax to have the code within "EOFs" flags interpreted as Ruby
/usr/bin/env ruby << EOFRUBY
puts "This is Ruby !"
EOFRUBY
