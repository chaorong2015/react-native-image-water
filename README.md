# react-native-image-water
＃iOS 设置九宫格位置的水印,初始图片大小,保存图片到新建相册
#### iOS
1. `npm install react-native-image-water --save`
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
3. Go to `node_modules` ➜ `react-native-camera` and add `RNImageWatermark.xcodeproj`
4. In XCode, in the project navigator, select your project. Add `RNImageWatermark.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
5. Click `RNImageWatermark.xcodeproj` in the project navigator and go the `Build Settings` tab. Make sure 'All' is toggled on (instead of 'Basic'). In the `Search Paths` section, look for `Header Search Paths` and make sure it contains both `$(SRCROOT)/../../../node_modules/react-native/React` and `$(SRCROOT)/../../react-native/Libraries` - mark both as `recursive`.
5. Run your project (`Cmd+R`)

####Demo
import { ImageWatermark } from 'react-native-image-water';
class CameraScreen extends React.Component {
	test = ()=> {
		//初始化图片大小
		let resizer = await ImageWatermark.createResizedImage(path, 300, 300, 'JPEG', 100, 0, DocumentDir);
		//给图片加水印
		let path = await ImageWatermark.addImageWatermark(path, watermarkText, watermarkPosition, DocumentDirectoryPath);
		//将图片保存新建相册
		let msg = await ImageWatermark.addPhotoAlbum(path, albumName);
	}
}
}

