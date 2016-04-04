#Moments

## Authors
- Alain Lemaire - https://github.com/jaxdid
- Douglas Rose - https://github.com/DouglasRose
- Reiss Johnson - https://github.com/reissjohnson
- Tom Pickard - https://github.com/tcpickard94
- Bjoern Wagner - https://github.com/BjoernWagner

##Project Overview
A social mobile app that allows people to express their emotions and experiences locally. On launching *Moments*, users are prompted to sign in via Facebook and are then taken to a a full-view map centered on their location that is dynamically updated in real-time through Firebase. Users can view moments from around the world and are able to create their own moments: brief snapshots of their mood or experiences represented by Momoji, an optional short description (up to 30 characters) and/or photo.

##Installation Instructions
Moments is built in Swift 2.0 and requires Xcode 7.3 to be run locally.

```
$ git clone https://github.com/BjoernWagner/moments
$ cd moments
$ pod install
$ open moments.xcworkspace/
```
In Xcode use `cmd + R` to run the code through the simulator of your choice.
Enter `cmd + U` to run the tests.

##Technologies
- Swift 2.0
- Xcode 7.3
- XCTest/Quick/Nimble
- Firebase
- Amazon Web Services S3
- Amazon Web Services Cognito
- Facebook SDK (iOS)

##Known Issues
- Latest image upload sometimes overwrite existing moments' images. 
- Unable to display standard subtitle details (user's name and timestamp) if image uploaded; image overwrites subtitle.
- Images currently uploaded synchronously to AWS S3; app will crash if user tries to create moment before upload is complete. 
- Inability to interact with moments that were created without text.
- UI constraints do not render UI elements correctly across devices. Currently works on 4.7-inch and larger screens.
- Momoji map markers do not always match user's choice when they were created.

##Screenshots
![login page](https://www.dropbox.com/s/rkqygh1beof2dx4/Screenshot%202016-04-04%2019.40.05.png?raw=1)
![map view](https://www.dropbox.com/s/h7n0cqel7aqcmea/Screenshot%202016-04-04%2019.41.20.png?raw=1)
![create moment](https://www.dropbox.com/s/wz0msi12zoib46k/Screenshot%202016-04-04%2019.43.13.png?raw=1)

##Implemented User Stories
```
As a user,
So that I can access the app,
I need to be able to sign in via Facebook.
```
```
As a user,
So that I can learn more about a particular Moment,
I want to be able to tap a Moment and see a context pop-up.
```

```
As a user,
So that I can identify the mood of a Moment,
I want to see its map marker represented as a Momoji.
```

```
As a user,
So that I can contribute to the platform,
I want to be able to create a moment.
```

```
As a user,
So that I can create a Moment,
I want to be able to access a form UI.
```

```
As a user,
So that I can confirm my Moment,
I want my map view to be recentered on my location after I submit.
```

```
As a user,
So that I can have control over my Moment,
I want to be able to delete a Moment I've created.
```

```
As a user,
So that I can participate in the app,
I want to see a map.
```

```
As a user,
So that I can see activity in my area,
I want to be able to see Moments within a 1-mile radius.
```

```
As a user,
So that I can see activity in other areas,
I want to be able to pan and zoom the map.
```

```
As a user,
So that I can return to my local area,
I want to be able to recenter the map on my current location.
```
