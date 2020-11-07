# Notes on how the code works




### Dark and Light Mode
To force the app to use a particular mode:
```
NSApp.appearance = NSAppearance(named: .darkAqua)
```
Used in ```MainViewController``` and ```PreferencesViewController```. [Source](https://developer.apple.com/documentation/appkit/nsappearancecustomization/choosing_a_specific_appearance_for_your_macos_app)  

If the system setting is ```.aqua```, the following will return true:
```
UserDefaults.standard.object(forKey: "AppleInterfaceStyle") == nil
```






### Preferences
Storing custom objects: [tutorial](https://www.tutorialspoint.com/how-to-store-custom-objects-in-nsuserdefaults)


To delete preferences:
```
defaults delete timbrewis.MIDIAnalyser
```

