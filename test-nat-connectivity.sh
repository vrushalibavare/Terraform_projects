#!/bin/bash
# Script to test NAT Gateway connectivity from an EC2 instance

echo "Testing internet connectivity via NAT Gateway..."

# Test DNS resolution
echo -n "DNS resolution test: "
if nslookup amazon.com > /dev/null 2>&1; then
  echo "PASSED"
else
  echo "FAILED"
fi

# Test HTTP connectivity
echo -n "HTTP connectivity test: "
if curl -s --connect-timeout 5 http://checkip.amazonaws.com > /dev/null; then
  echo "PASSED"
  echo "Your public IP is: $(curl -s checkip.amazonaws.com)"
else
  echo "FAILED"
fi

# Test HTTPS connectivity
echo -n "HTTPS connectivity test: "
if curl -s --connect-timeout 5 https://www.amazon.com > /dev/null; then
  echo "PASSED"
else
  echo "FAILED"
fi

# Test ping (may be blocked by security groups/NACLs)
echo -n "ICMP connectivity test: "
if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
  echo "PASSED"
else
  echo "FAILED (Note: ICMP may be blocked by security groups or NACLs)"
fi

# Check route to internet
echo "Route to internet:"
ip route get 8.8.8.8