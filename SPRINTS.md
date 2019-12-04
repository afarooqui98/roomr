# Meeting Notes

### Meeting 1
The first meeting was mostly focused on setting up the environement as well as some of the logistical stuff, like trello. Additionally, we organized a weekly meeting time of Thursday afternoon for a proper in person meeting. The online/slack meetings have yet to be decided. By next week, the goal is to have the layout and more straightforward views finished. For next week's meeting, the plan is to figure out what exactly the workload/workflow will be for each of the controllers that we need to implement, as almost all the distinct functionality is managed by some API. We also need to start define the objects that we'll be creating/working with in terms of passing user data between server, application, and the multiple views the application has. 

### Meeting 2
The second meeting was where we configured most of the team roles. By Thursday, we everyone should finish their respective layout for the main View Controllers. As outlined in the eventual documentation for milestone, we also started working to figure out leverage Firebase along with other third party packages to our advantage. The resulting delegation is as follows:
- Ryan: Firebase read/write, Camera Roll integration
- Katie: Firebase read multiple profiles, Koloda (tinder card swiping)
- Sophia: Firebase project setup, Message Kit
- Ahmed: Firebase Authentication, API endpoints (matching logic)
The weekly goals have been outlined softly in the first milestone, and there are entries in the trello board for the eventual firebase integration that has to be handled.

### Meeting 3
This week's Monday sprint focused mostly on pushing some initial week 2 changes to the repo. Here is the breakdown of what was pushed:
- Katie: Home controller with side bar functionality and aesthetic changes
- Ryan: profile view update
- Sophia: Uploading chats from firebase
- Ahmed: Saving data to firebase after login, hooking up proper login flow

By the end of Thursday, all of the flows should be put together so a coherent user flow may be navigated, even though not all funcionality may be enabled. All flows should be able to save and read data from the database coherently.

### Meeting 4
This week's sprint will probably be somewhat intense given the holidays. Push notifications still need to be implemented, and there's still work that needs to be done putting all the controllers together. These are the final tasks:
- Ahmed: enable push notifications
- Ryan: finish off profile view/flow/aesthetics
- Sophia: have working match screen with notifications sent to users
- Katie: filter profiles

### Meeting 5
It's the final stretch. Here are the assignments:
- Ahmed: 
  - Meet with Katie to make sure user matches are working, simulate like/dislike and match flow.
  - Meet with Sophia to simulate messaging flow
  - Meet with Ryan to finish off the profile view (media loading and storing)
  - clean up code
- Everybody else: clean up their respective code, make sure errors are handled sufficiently
