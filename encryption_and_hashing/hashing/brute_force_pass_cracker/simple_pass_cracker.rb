## MD5 Hash Brute Force Cracker

require 'digest/md5'
require 'gentle_brute'

## Example
# target_hash = Digest::MD5.hexdigest("poop")

# Set default password hash if user doesn't enter one
if ARGV[0]
	target_hash = ARGV[0]
else
	target_hash = '098f6bcd4621d373cade4e832627b4f6'
end

word_list = GentleBrute::BruteForcer.new

message = "Cracking password..."
puts message
num_tries = 0

while true
	## Pending message every 10 tries
	num_tries += 1
	puts message if (num_tries % 10).eql? 0

	## Use a word from word list to test
	phrase = word_list.next_valid_phrase
  ## Hash that word to compare to password hash
  attempt_hash = Digest::MD5.hexdigest(phrase)

  ## If the hashes match, print the unhashed phrase (password)
  if attempt_hash == target_hash
  	puts "Cracked!"
  	puts "Password is #{phrase}"
  end

  break if attempt_hash == target_hash
  puts "Tried #{phrase}, not a match. Still trying to crack..."

end