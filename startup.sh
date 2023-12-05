
#!/bin/bash

echo "startup started!"

# Add logging and debugging lines
exec >> /tmp/startup.log 2>&1
set -x

# Add a delay at the beginning
sleep 30

# Step 1: Create 5 files on the host system
for i in {1..2}; do
    touch /home/sauravnegi7000/Documents/issue#6/file$i
done

# Step 2: Update the files every 5 seconds
#while true; do
    for i in {1..2}; do
        echo "Content for file$i - $(date)" > /home/sauravnegi7000/Documents/issue#6/file$i
    done
    sleep 1
#done
