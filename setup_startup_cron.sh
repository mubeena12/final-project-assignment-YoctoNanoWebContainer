
#!/bin/bash

# Define the script path
SCRIPT_PATH="/home/sauravnegi7000/Documents/issue#6/startup.sh"

# Add the @reboot cron job
(crontab -l 2>/dev/null; echo "@reboot $SCRIPT_PATH") | crontab -
