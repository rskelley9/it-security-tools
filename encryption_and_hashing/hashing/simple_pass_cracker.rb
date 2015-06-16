# MD5 Hash Collision Cracker

require 'digest/md5'
require 'gentle_brute'

target_hash = '58e53d1324eef6265fdb97b08ed9aadf'

word_list = GentleBrute::BruteForcer.new

message = "Cracking password..."
puts message
num_tries = 0

while true
	# Pending message every 10 tries
	num_tries += 1
	puts message if (num_tries % 10).eql? 0

	# Use a word from word list to test
	phrase = word_list.next_valid_phrase
  # Hash that word to compare to password hash
  attempt_hash = Digest::MD5.hexdigest(phrase)

  # If the hashes match, print the unhashed phrase (password)
  if attempt_hash == target_hash
  	puts "Cracked!"
  	puts "Password is #{phrase}"
  end

  break if attempt_hash == target_hash
	puts "Tried #{phrase}, not a match. Still trying to crack..."

end