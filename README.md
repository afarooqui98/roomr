# Roomr
Trello Board: https://trello.com/b/hp9w4Hu1/weekly-sprints

Designs: Balsamiq + Design file both in design folder as well as some assets

### All information is in the milestone 1 document

## More information on Roomr:
__Purpose:__ Help students find roommates & housing.

__App Features:__

**Under Login**, *Done by Ahmed Farooqui*
* Login with Google account
* Profile Setup:
    - *name, gender, gender greference, cleanliness, loudness, DOB, looking/offering a room...*
    - *upload images (of user &/ their room)*
* Storing these user profiles in realtime database on Firebase
*  *Push Notifications also done by Ahmed*

**Under Settings**, *Done by Chak Hin Ryan Chan*
* Editing profile info & preferences:
    - Profile: *(name, bio, gender, DOB, looking/offering a room)*
    - Preferences: *(roommate gender, phone number, user's cleanliness & volume)
* Viewing uploaded photos stored under user's account
* Updating any changes made in settings in Firebase

**Under Home**, *Done by Katie Kwak*
* Loading user profiles from Firebase & filtering out users that are incompatible with current user's preferences.
* Tinder-style card swiping (store left & right swipes in Firebase)
* Detecting & notifying when two users match (observe Firebase) & storing match info in Firebase.

**Under Matches**, *Done by Songwen Su*
* Load current user's matches from Firebase into collection view
* Logic on tracking 'Friend' status by reading & writing from/to Firebase.
* If only 1 person wants to talk, display notification asking user if they want to talk. Otherwise (if both want to talk to each other) move from 'matches' to 'friends' view & status. 

### Team Members:
![Ahmed](https://user-images.githubusercontent.com/32757527/68828949-30943a80-065c-11ea-9180-816ef9183f4d.png)
**Ahmed Farooqui, @afarooqui98**


![Sophia](https://user-images.githubusercontent.com/32757527/68828997-528dbd00-065c-11ea-8c33-0094ff752434.png)
**Sophia Su, @SongwenSu**

![Ryan](https://user-images.githubusercontent.com/32757527/68829008-56214400-065c-11ea-85ed-2cc15b9da0ba.png)
**Chak Hin Ryan Chan, @ryancch**

![Katie](https://user-images.githubusercontent.com/32757527/68829010-57eb0780-065c-11ea-884c-b0dfb39f842b.png)
**Katie Kwak, @kykwak**
