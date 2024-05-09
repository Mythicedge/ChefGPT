# recipetestapp
 
https://docs.flutter.dev/get-started/install/windows/mobile

Open the repo with github desktop, open project with vss from there Install Flutter extension in vss.

When that finishes installing, it will tell you to install the flutter sdk in the bottom right. It will tell you to install it in a folder, create a new folder named dev on your drive so that the flutter sdk can be cloned. When it finishes, it will ask if you want to add Flutter SDK to path, click it "Add SDK to PATH". You HAVE to restart your computer for flutter to work. (It might ask you again if you want to install sdk again, or locate sdk. This time click on locate sdk, and select the dev folder)

On the bottom right of your vss, click on where you could select devices, and select an android device. Once that emulator starts up, press F5 in vss, and it will finally start this flutter project. First runtime will take a few minutes. You may need to run the command "dart pub get" in the terminal.

flutter clean
flutter pub get
flutter run
Then press F5 to start debugging
