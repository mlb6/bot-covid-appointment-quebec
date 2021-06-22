# Informations used to connect to the website:
RAMQ=''
# format : 5144153000
PHONE=''

# The phone you wish to send the alerts to (need to be a different number to yours) 
ALERT_BY_PHONE=''

# Periods you are looking for: Format is <Start date>|<End date>#<Start date 2>|<End date 2>
# example: 2021-07-09|2021-08-15#2021-07-25|2021-08-30
PERIODS_DEF='2021-07-01|2021-08-30'

# SERVICE_ID: probably the vaccine ID (For me, Moderna was 8155)
SERVICE_ID=

# PLACE_ID: The location you got vaccinated the first time. (Olympic stadium: 2013)
PLACE_ID=

# As every hour your session will end, the bot needs to connect to your e-mail to get the MFA code
IMAP_USER=
IMAP_PASSWORD=

# Those values are provided by your E-Mail provider
IMAP_HOST='imap.gmail.com'
IMAP_PORT=993

# if you receive the email in english change this value to "Identity Confirmation"
EMAIL_SUBJECT="Confirmation d'identité"


# It will renew your session every 45min. Token are valid for 60min.
SESSION_RENEWAL=45
