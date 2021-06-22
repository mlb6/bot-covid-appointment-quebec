# Covid vaccine appointment bot

This bot can be used to look for appointment availabilities. This work only on Mac OS X but could be adapted for other platform. (MR welcomed)
It sends a link to a phone number using your iMessage app, and will also warn you with a Mac OS Notification.

## Instalation

### Basic tooling

If your not a developer you will need to install some basic tools.
Open your terminal in "Applications" > "Utilities" and execute the following commands

Homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Yarn
```
brew install yarn
```

### bot
Clone this repository with git, or [download it](https://github.com/mlb6/bot-covid-appointment-quebec/archive/refs/heads/main.zip) and extract it.

```
yarn install && yarn install:mac
```

## Configuration
Open the `.env` file to edit the configuration


Request URL: https://api3.clicsante.ca/v3/establishments/60098/schedules/day?dateStart=2021-07-31&dateStop=2021-08-01&service=8190&timezone=America/Toronto&places=2758&filter1=undefined&filter2=undefined&filter3=undefined
