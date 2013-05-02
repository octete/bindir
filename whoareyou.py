#!/usr/bin/python

# Find out who is running this script over SSH, by:
# 1. Asking ssh-agent for their known key fingerprints
# 2. Looking for a matching key in .ssh/authorized_keys, and reporting the key
#        comment.

import binascii
import os
import warnings
warnings.filterwarnings('ignore', '[Tt]he (md5|popen2) module is deprecated', DeprecationWarning)
import md5
import popen2

def determine_identity():
    agent_fingerprints = []
    ssh_add = popen2.Popen4(['ssh-add', '-l'])
    for line in ssh_add.fromchild.readlines():
        try:
            keylength, fingerprint, remainder = line.split(' ', 2)
        except ValueError:
            pass
        agent_fingerprints.append(fingerprint.replace(':', ''))
    try:
        for line in open(os.path.expanduser('~/.ssh/authorized_keys')):
            try:
                keytype, blob, comment = line.strip().split(' ', 2)
                fingerprint = md5.md5(binascii.a2b_base64(blob)).hexdigest()
            except (ValueError, binascii.Error):
                continue
            if fingerprint in agent_fingerprints:
                return comment
    except IOError:
        # no file, we ignore
        pass
    return "<unknown>"

if __name__ == '__main__':
    print determine_identity()
