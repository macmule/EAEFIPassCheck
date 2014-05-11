#!/bin/sh
####################################################################################################
#
# More information: http://macmule.com/2014/05/04/submit-user-information-from-ad-into-the-jss-at-login-v2/
#
# GitRepo: https://github.com/macmule/EAEFIPassCheck
#
# License: http://macmule.com/license/
#
####################################################################################################

# Check to see if setregproptool exists in correct location.
if [ -f "/Library/Application Support/JAMF/bin/setregproptool" ]; then
	
	# Use expect so command times out
	EFIPasswordSet=$(expect <<- DONE
		# Timeout after 2 seconds
		set timeout 2
		# Try & delete firmware password but without sending a password.
		# Password prompt is only received is password set.
		spawn sudo /Library/Application\ Support/JAMF/bin/setregproptool -d
		# If "Enter current password:" prompt returned
		expect "*nter current password:*"
	DONE)

	# If $EFIPasswordSet contains the word "current" then we have been prompted
	# for a firmware password, then return "Set"
	if [[ "$EFIPasswordSet" == *current* ]]; then
		echo "<result>Set</result>"	
	# Else return "Not Set"
	else
		echo "<result>Not Set</result>"	
	fi
	
# If setregproptool does not exist in correct location.
else
	echo "<result>Not Found</result>"
fi
