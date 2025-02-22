# VDrop
This macOS app is a "wrapper" for FFmpeg. It lets you drag and drop a video file which it then uses FFmpeg to convert to .mp4 and reduce the file size. You can also optionally scale the video dimensions down to make it smaller.

I made this app because I frequently use FFmpeg to reduce the file size of videos I have created in the iOS simulator. I reduce the file size before sharing with others in Slack/Teams/Jira etc. I also sometimes downscale the video dimensions so that it doesn't appear gigantic in my PR descriptions.

## Building the project
1. Requires Xcode 16.2 on macOS Sonoma or later.
2. Clone the repo.
3. In Terminal, navigate to the root of the repo and run this command:

```
cp Configuration-template.xcconfig Configuration.xcconfig
```

4. Update `Configuration.xcconfig`
  - Replace `YOUR_TEAM_ID` with your Team ID from Apple Developer Portal.
  - Update `PRODUCT_BUNDLE_IDENTIFIER` with desired Bundle ID.
5. Save changes to the file. The project should now build.
6. The `Configuration.xcconfig` is in the `.gitignore` file, so it won't be committed.

## Known TODOs
- Assumes FFmpeg is installed on your system in `/opt/homebrew/bin/`. Won't work without it.
- FFmpeg could fail. There is currently no error messaging.

## Demo Video
![Demo video](demo.gif)
