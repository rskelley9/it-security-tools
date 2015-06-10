## WIP: This file is a work-in-progress

# require 'digest/md5'
# require 'gentle_brute'

# target_hash = '58e53d1324eef6265fdb97b08ed9aadf'

# b = GentleBrute::BruteForcer.new
# while true
#   phrase = b.next_valid_phrase
#   attempt_hash = Digest::MD5.hexdigest(phrase)
#   puts "Password is #{phrase}" if attempt_hash == target_hash
#   break if attempt_hash == target_hash
# end