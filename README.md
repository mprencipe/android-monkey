# android-monkey
A script for automating monkey tests. Includes login and permission grant support. Suitable to be run in a CI environment.

How it works:
1. Gets list of devices from adb and starts iterating
2. If the device requires a permission it is granted
3. Logs in with the provided username and password
4. Starts monkeying around

The seed parameter can be used to replicate the series of events sent to the devices.

Adb seems to always return a code 0 even if things go wrong, so you need to grep the logs yourself for "Monkey aborted due to error" to evoke a failure.
