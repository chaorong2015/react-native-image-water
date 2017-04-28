# react-native-shared-images
＃ 打印 PDF
#### iOS
1. `npm install react-native-portable-print --save`
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
3. Go to `node_modules` ➜ `react-native-portable-print` and add `RNPortablePrint.xcodeproj`
4. In XCode, in the project navigator, select your project. Add `RNPortablePrint.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
5. Click `RNPortablePrint.xcodeproj` in the project navigator and go the `Build Settings` tab. Make sure 'All' is toggled on (instead of 'Basic'). In the `Search Paths` section, look for `Header Search Paths` and make sure it contains both `$(SRCROOT)/../../../node_modules/react-native/React` - mark both as `recursive`.
5. Run your project (`Cmd+R`)
6.Edit information property list.
Note: Please do not apply this, if you are not using Bluetooth ineterface.
1. Click on the information property list file (default : “Info.plist”).
2. Add the “Supported external accessory protocols” Key.
3. Click the triangle of this key and set the value for the “Item 0” to “jp.star-m.starpro”.

```js

####使用说明

##1、先引用库
import { PortablePrint } from 'react-native-portable-print';

##2、接口说明
/*测试插件*
＊@para msg string
*/
let msg = await PortablePrint.testPrint(msg);

##2、接口说明
/*打印pdf*
＊@para portName string
＊@para portSettings string
*/
let msg = await PortablePrint.printPDF(portName,portSettings);
