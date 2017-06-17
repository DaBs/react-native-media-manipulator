
# react-native-react-native-media-manipulator

## Getting started

`$ npm install react-native-react-native-media-manipulator --save`

### Mostly automatic installation

`$ react-native link react-native-react-native-media-manipulator`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-media-manipulator` and add `RNMediaManipulator.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNMediaManipulator.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.davidbjerremose.reactnativemediamanipulator.RNMediaManipulatorPackage;` to the imports at the top of the file
  - Add `new RNMediaManipulatorPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-media-manipulator'
  	project(':react-native-media-manipulator').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-media-manipulator/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-media-manipulator')
  	```


## Usage
```javascript
import RNMediaManipulator from 'react-native-media-manipulator';

RNMediaManipulator.mergeImages({
  uri: 'https://example.com/image.png',
  width: 1000, // height of final image
  height: 500 // width of final image
}, [
  {
    uri: 'http://example.com/otherimage.png', // URI for other image you want merge on top of the background,
    width: 200, // width of image
    height: 200, // height of image
    scale: 1, // scale of image
    rotate: '0deg', // rotation of image
    x: 20, // x position of image
    y: 200 // y position of image
  }
]).then(uri => {
  // do something with your new image that is stored in tmp
}).catch(error => {
  // something went wrong creating the image.
})
```
  
