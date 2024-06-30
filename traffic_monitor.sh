#!/bin/bash

# Threshold for outgoing traffic in KB/s (e.g., 500 Mbps)
THRESHOLD=62500

# Burst allowance in KB (e.g., 100 MB)
BURST=102400

# Check outgoing traffic using ifstat
OUTGOING=$(ifstat -i eth0 1 1 | awk 'NR==3 {print $7}')

# Read the current burst count
if [ -f /tmp/burst_count ]; then
  BURST_COUNT=$(cat /tmp/burst_count)
else
  BURST_COUNT=0
fi

# Check if outgoing traffic exceeds the threshold
if (( $(echo "$OUTGOING > $THRESHOLD" | bc -l) )); then
  BURST_COUNT=$((BURST_COUNT + OUTGOING))
  echo $BURST_COUNT > /tmp/burst_count

  if (( BURST_COUNT > BURST )); then
    echo "High outgoing traffic detected: $OUTGOING KB/s"
    echo "Blocking internet access..."

    # Block outgoing traffic
    sudo iptables -A OUTPUT -o eth0 -j DROP
    logger "High outgoing traffic detected: $OUTGOING KB/s. Internet access blocked."

    # Sleep for a while before re-enabling (e.g., 1 minute)
    sleep 60

    # Re-enable outgoing traffic
    sudo iptables -D OUTPUT -o eth0 -j DROP
    echo "Internet access re-enabled."
    echo 0 > /tmp/burst_count
  fi
else
  BURST_COUNT=0
  echo $BURST_COUNT > /tmp/burst_count
  echo "Traffic is normal: $OUTGOING KB/s"
fi
