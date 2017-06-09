=================
INSTRUCTIONS
=================

- You are to create an iOS Mobile application that looks and functions as specified in the wireframe.pdf
- A partially completed starter project (IOSProgrammerTest) is supplied to help you get started.
- There are 4 main sections in the mobile app: Home, Chat, Login, and Animation Test.
- Please take care of the bug(s) we left for you in the starter project as well.
- For all intents and purposes, you now own the starter project code, you can add, remove, or edit any code as you see fit.

=================
APP SECTIONS
=================

- Home: This is a very simple screen, all it does is have buttons that lead you to the other screen in the app.

- Chat: This section simply displays a list of an old chat log from some cached data, however the user images in the chat
must be dynamically downloaded from the provided urls.

- Login: This is your typical mobile app's login screen, where a user enters their credentials and attempts to login. Details
on what HTTP Endpoint to query and what the UI should do upon a successful login are specified inside the wireframe.pdf

- Animation Test: The basic requirements for this screen is that when the spin button is tapped
the AppPartner logo rotates 360 degrees Counter-Clockwise once every time the spin button is tapped. The use must also be able to tap and drag the
icon around the screen. After fulfilling those requirements, try to show us something cool on this screen! Maybe after you tap the spin button some music starts playing, and a crazy light show start happening around on the screen. Maybe the AppPartner icon explodes if I drag it around too much, almost anything is fair game here, be creative and impress us!

=================
REQUIREMENTS
=================

1. Your App must support iOS8 and iOS9. Portrait Orientation only.
2. You must support the iPhone4s, iPhone5, iPhone5s, and iPhone6.
3. You must use AutoLayout.
4. Do not worry about supporting the iPhone 6 Plus.
5. Please make use of the starter project (IOSProgrammerTest) and complete all sections.
6. Please use the existing project’s XIBs for all of your UI, do not use Storyboard.

==============================
WHAT AM I BEING TESTED ON ???
==============================

1. Your ability to pick up and work in a foreign codebase.
2. Your ability to follow directions.
3. Your ability to implement features common to most mobile applications.
4. Your ability to write clean and maintainable code.
5. Your ability to find and fix bugs in an existing codebase.
6. Your ability to be creative.


Thank you and Good luck. - App Partner

====================
COMMON QUESTIONS
====================

Q:    Can we use available GitHub libraries available to implement the task?
A:    Yes, as long as it is made apparent where the library/code was taken from.

============================================================================================================================================

Q:    The background images provided are sized for a 3.5" screen. 
      Should I make the app compatible with 4" devices, or will it only be run in the 3.5" iOS Simulator?

A:    Yes, the application needs to be compatible with 4" devices.

============================================================================================================================================

Q:    From the chat part, the icon of each person was not provided in the asset folder.
A:    The icon of each person must be downloaded from our server. Take a look at the ChatData class and the avatarURL property.

============================================================================================================================================

Q:    My Network calls to your login.php endpoint are not working?
A:    Please make sure that you are sending us the POST data correctly. Take a look at the postman_reference.jpg image provided if you are confused.

============================================================================================================================================