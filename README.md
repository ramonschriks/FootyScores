
## Intro ##
This app is build using the API from https://apifootball.com/. I want to thank this company for giving me an extended access to their services for developing this application.

This application is build for educational purposes.

## How to use? ##
To use this application, get yourself an api-key from https://apifootball.com/, and place it inside the following file:
```FootyScores/Clients/ApiFootballClient.swift```

## Features ##
The current features of this application, as of the latest changes, are:

- Scheduled and Live football events from over the world (provided by: https://apifootball.com/)
- Subscribe to multiple events to receive push-notifications about all subscribed events for goals and cards
- View recent results back to 3 days
- View Todays results/live events
- View scheduled events up to 3 days
- View detailed match info for each event

## Note ##
For demo purposes, the background services are scheduled every 5 seconds (interval). Please see the ```NotificationService.swift``` for the correct initialize of this interval.

## Screenshots ##
![Alt text](/Screenshots/todays events.jpeg?raw=true "Today's events")

