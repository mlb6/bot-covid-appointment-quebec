# Covid vaccine appointment bot

This bot can be used to look for appointment availabilities. This work only on Mac OS X but could be adapted for other platform.
It sends a link to a phone number using your iMessage app, and will also warn you with a Mac OS Notification.

This is provided as is... feel free to improve it. (Pull Request welcome)

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
Open the `env.sh` file to edit the configuration

With the network tab of your browser you will have to look for a "place" id and a "service" id in a URL looking like that :
```
https://api3.clicsante.ca/v3/establishments/60098/schedules/day?dateStart=2021-07-31&dateStop=2021-08-01&service=8190&timezone=America/Toronto&places=2758&filter1=undefined&filter2=undefined&filter3=undefined
```

## Start
```
yarn start
```

# Contributing
Feel free to send me PR.