# boinc-awattar
Shell script that manages BOINC so that it only runs, when energy prices are low indicating a surplus of renewable energy

## Installation
1. Copy the shell script into a custom location and change the variables according to your needs. Especially the $file variable in line 5 should be accurate.
2. Create a crontab or another way to run this script after a new hour has started

### Sample crontab
This crontab runs the control script every hour. In case the time is not exactly in sync I decided to wait for one minute after the full hour.

```
1 * * * * /path/to/controller.sh
```
