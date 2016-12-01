# react-native-image-water
＃iOS 设置九宫格位置的水印,初始图片大小,保存图片到新建相册
#### iOS
1. `npm install react-native-image-water --save`
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
3. Go to `node_modules` ➜ `react-native-camera` and add `RNImageWatermark.xcodeproj`
4. In XCode, in the project navigator, select your project. Add `RNImageWatermark.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
5. Click `RNImageWatermark.xcodeproj` in the project navigator and go the `Build Settings` tab. Make sure 'All' is toggled on (instead of 'Basic'). In the `Search Paths` section, look for `Header Search Paths` and make sure it contains both `$(SRCROOT)/../../../node_modules/react-native/React` and `$(SRCROOT)/../../react-native/Libraries` - mark both as `recursive`.
5. Run your project (`Cmd+R`)

```js

####使用说明

##1、先引用库
import { ImageWatermark } from 'react-native-image-water';

##2、接口说明
/*初始化图片大小*
＊@para path         string   要初始化的图片物理地址
＊@para width        int      重新设置宽
＊@para height       int      重新设置高
＊@para format       string   格式化类型(JPEG、PNG)
＊@para quality      int      图片质量(0-100)
＊@para rotation     int      图片旋转角度(0-360)
＊@para outputPath   string   图片导出后保存的物理位置
＊@retrun promise    string   返回图片保存的物理位置
*/
let outputPathNew = await ImageWatermark.createResizedImage(path, width, height, format, quality, rotation, outputPath);

/*给图片加水印*
＊@para path                 string   要加水印的图片物理地址
＊@para watermarkText        string   水印字体
＊@para watermarkPosition    int      水印在九宫格位子（1-9）
＊@para watermarkSize        int      水印字体大小
＊@para outputPath           string   图片导出后保存的物理位置
＊@retrun promise            string   返回图片保存的物理位置
*/
let path = await ImageWatermark.addImageWatermark(path, watermarkText, watermarkPosition, watermarkSize, outputPath);

/*将图片保存新建相册*
＊@para path            string   要保存的图片物理地址
＊@para albumName       string   要保存到的新建相册名称
＊@retrun promise       string   返回是否保存成功的信心
*/
let msg = await ImageWatermark.addPhotoAlbum(path, albumName);

