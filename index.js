'use strict';
const { NativeModules } = require('react-native');
const RNImageWatermark = NativeModules.RNImageWatermark;
module.exports.ImageWatermark = {
	createResizedImage: (path, width, height, format, quality, rotation = 0, outputPath) => {
    if (format !== 'JPEG' && format !== 'PNG') {
      throw new Error('Only JPEG and PNG format are supported by createResizedImage');
    }
    return new Promise((resolve, reject) => {
      NativeModules.RNImageWatermark.createResizedImage(path, width, height, format, quality, rotation, outputPath, (err, resizedPath) => {
        if (err) {
          return reject(err);
        }

        resolve(resizedPath);
      });
    });
  },
  addImageWatermark: (path, str='', positionstr= 1, outputPath) => {
    return new Promise((resolve, reject) => {
      NativeModules.RNImageWatermark.addImageWatermark(path, str, positionstr, outputPath, (err, addWatermarkPath) => {
        if (err) {
          return reject(err);
        }
        resolve(addWatermarkPath);
      });
    });
  },
  testPrint: () => {
  	console.log('RNImageWatermark=testPrint=', RNImageWatermark);
    return new Promise((resolve, reject) => {
	    RNImageWatermark.testPrint("test message",(error, data) => {
			  if (error) {
			    console.log(error);
			    return reject(error);
			  } else {
			    console.log(data);
			    resolve(data);
			  }
		});
    });
  }
};