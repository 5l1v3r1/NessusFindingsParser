Nessus Findings Parser
======================

This project can be used to quickly extract findings by Id and Name from the Nessus .nasl files.

Prerequisites
-------------
This project uses the 'trollop' gem. To install it, run 'bundle install' from the project root.

Example Usage
-------------
mandreko@ubuntu:~$ ./nessus_findings_parser.rb -i /opt/nessus/lib/nessus/plugins/ -o out.csv