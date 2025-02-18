# VDrop
This macOS app is a "wrapper" for FFmpeg. It lets you drag and drop a video file which it then uses FFmpeg to convert to .mp4 and reduce the file size. You can also optionally scale the video dimensions down to make it smaller.

I made this app because I frequently use FFmpeg to reduce the file size of videos I have created in the iOS simulator. I reduce the file size before sharing with others in Slack/Teams/Jira etc. I also sometimes downscale the video dimensions so that it doesn't appear gigantic in my PR descriptions.

## Building the project
- Requires Xcode 16.2 on macOS Sonoma or later.
- Update `Configuration.xcconfig`
  - Replace `YOUR_TEAM_ID` with your Team ID from Apple Developer Portal.
  - Update `PRODUCT_BUNDLE_IDENTIFIER` with desired Bundle ID.

## Known TODOs
- Assumes FFmpeg is installed on your system in `/opt/homebrew/bin/`. Won't work without it.
- FFmpeg could fail. There is currently no error messaging.

## Demo Video
![Demo video](demo.gif)
