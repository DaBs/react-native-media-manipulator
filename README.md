
# react-native-react-native-media-manipulator

## Getting started

`$ npm install react-native-react-native-media-manipulator --save`

### Mostly automatic installation

`$ react-native link react-native-react-native-media-manipulator`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-react-native-media-manipulator` and add `RNReactNativeMediaManipulator.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNReactNativeMediaManipulator.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNReactNativeMediaManipulatorPackage;` to the imports at the top of the file
  - Add `new RNReactNativeMediaManipulatorPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-react-native-media-manipulator'
  	project(':react-native-react-native-media-manipulator').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-react-native-media-manipulator/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-react-native-media-manipulator')
  	```


## Usage
```javascript
import RNReactNativeMediaManipulator from 'react-native-react-native-media-manipulator';

// TODO: What to do with the module?
RNReactNativeMediaManipulator;
```
  