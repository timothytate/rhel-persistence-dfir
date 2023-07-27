RHEL Persistence Collection Script
===================================
This script is designed to collect information from a RHEL system to later analyze, detect, and respond an adversary's persistent mechanisms.  The script will collect the following information:

* Startup scripts  
* Kernel Modules
* Software Packages
* Cron and AT jobs
* Users
* Filesystem Information
* Systemd Generators
* Systemd Service Paths (System and User)

Recommended Reading: [Pepe Berba's Threat Hunting for Persistence on Linux](https://pberba.github.io/security/2021/11/23/linux-threat-hunting-for-persistence-account-creation-manipulation/#introduction)