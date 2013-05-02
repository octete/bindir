#!/usr/bin/ruby 

# Based on whoareyou.py

require 'digest/md5'
require 'base64'


def determine_identity()
	#puts 'starting determine_identity'
	agent_fingerprints = []
	IO.popen("ssh-add -l") {|line|
	  l = line.gets
	  keylen, fingerprint, rest = l.split(' ', 3)
	  agent_fingerprints << fingerprint.gsub(/:/,"")
  }
  # Read authorized_keys file
  File.open(File.expand_path("~/.ssh/authorized_keys")).each do |line|
    keytype, blob, comment = line.split(' ', 3)
    fingerprint = Digest::MD5.hexdigest(Base64.decode64(blob))
    #agent_fingerprints << fingerprint
    if agent_fingerprints.include?(fingerprint) then
      return comment
    end
  end
  return "<unknown>"


end

puts determine_identity
