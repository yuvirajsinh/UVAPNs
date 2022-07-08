# UVAPNs
A simple Mac app built with SWiftUI to send Push notification using APNs.

<img src="/Resources/UVAPNs_screenshot.png" width="400" height="700" />

## About
It is an utility app to send Push Notification using APNs which can be used by Developers to test Push notification integration in your apps. So you can be sure that app behaves the way it should be.

Begore you start using it please go through following limitations:

  1.  Only Token-Based APNs connection is supported, Certificate-Based connection is not supported.
  2.  Can send notification to only one device at a time.
  3.  Message should include full payload.
  
### Sample payload
```
{
   "aps" : {
      "alert" : {
         "title" : "Hey Yuvi!",
         "subtitle" : "Good morning",
         "body" : "You have important meetings today"
      },
      "category" : "MEETING_REMINDER"
   },
   "user_info_1" : "Hey",
   "user_info_2" : "there"
}
```
## How to run
It's simple, like any other Xcode project
  1.  Clone project
  2.  Open project using `UVAPNs.xcodeproj` file _(If you are opening it for first time it will sync dependencies using SPM that may take few minutes)_
  3.  Run project and use the app
