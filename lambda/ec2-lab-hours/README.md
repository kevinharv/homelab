# EC2 Lab Hours

*Automatically power up or down EC2 VMs during hours.*

## Overview

Locates all EC2 VMs with <insert tag here> and powers them on during lab tinkering hours.

## Schedules

CRON Schedules:
- Power On (Weekdays): 0 17 ? * 2,3,4,5,6 *
- Power On (Weekends): 0 8 ? * 1,7 *
- Power Off (Weeknights): 0 22 ? * 1,2,3,4,5 *
- Power Off (Weekends): 0 23 ? * 6,7 *