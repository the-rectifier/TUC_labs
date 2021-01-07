ACE414 - Services and Systems security
2018030199 - Stavrou Odysseas 

I created two functions, add_rule() which adds a new rule into the filter table on the INPUT chain, and resolve() which resolves a hostname into IPv4 ips and 
then calls the add_rule() function. The INPUT chain is used so that any packet from that address will be rejected

    1.) For each domain in domainNames.txt the resolve function runs in the background resolving the hostname.
        dig may return some hostnames so a simple regex was used to match only ip addresses, then for each IP the add rule is used.

    2.) For each IP in IPAddresses.txt just add it to the rules

    3.) Since the script required root permissions, the iptables command should be an absolute directory.

    4.) After applying the rules browsing into an ab-blocking-testing site i could still see ads although some were blocked, but some frames were still visible.
        This is due to the short list of domain names in our disposal (professional ad-blockers use about 50k hostnames).
        Also ads may be pop-ups/redirections/notification pops-up, which our crude ad-blocker didn't have any effect on them.
        A better alternative than rules would be to block using the hosts file like professional ad-blockers, and it would also be more efficient than the iptables

    5.) For the remaining operations the script is just a wrapper around the iptables commands providing the correct arguments and input/outpuτ redirection to save/load
        to and from specific files.

    Note: This tool is useless against in-video youtube ads because youtube does not use domains for these ads, but rather one hostname for both video and ads.
