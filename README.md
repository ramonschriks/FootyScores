
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

## Internal Structure ##
- Usage off async queue's (main/global) for fluid user experience
   - ie. for the favorites, we have a list of matchId's we want to retrieve. However, the API supports only 1 matchId per time. So we need to requests all events individually. While we do do this (```EventService:getEvents(byIds)```), we wait until all requests are finished, and then return the full list of events. In the controller which calls this method, we use async off the main queue to not wait for it.
   
- Correct usage of extending classes to reduce duplicate code used by multiple classes 
(example: FootyScores/FootyScores/Events/EventsTableViewDataSource.swift
   - is used as an abstract class
   - for EventViewController.swift
   - for FavoriteViewController.swift

- Usage of external API's and parsing the JSON into domainObjects
- Smart sorting abilities to sort all events in the leagues/countries they belong to (```EventService.swift```)
- Timer for running specific methods in the background. We need this (for testing purposes) to check if there are changes in our favorite events. When there are changes, we send a pushnotification to the user.
- Push Notification Service to send the notification with a 5 second delay.


## Note ##
For demo purposes, the background services are scheduled every 5 seconds (interval). Please see the ```NotificationService.swift``` for the correct initialize of this interval.

## Screenshots ##
![Alt text](/Screenshots/today.jpeg?raw=true "Today")
![Alt text](/Screenshots/scheduled.jpeg?raw=true "Scheduled")
![Alt text](/Screenshots/results.jpeg?raw=true "Results")
![Alt text](/Screenshots/favorites.jpeg?raw=true "Favorites")
![Alt text](/Screenshots/details.jpeg?raw=true "Details")
![Alt text](/Screenshots/notifications.jpeg?raw=true "Notifications")



