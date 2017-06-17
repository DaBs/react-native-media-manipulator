
package com.davidbjerremose.reactnativemediamanipulator;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.drawable.BitmapDrawable;
import android.util.Base64;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;

import java.io.File;
import java.io.FileOutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

public class RNMediaManipulatorModule extends ReactContextBaseJavaModule {

    private static final String TAG = "RNMediaManipulator";

    private final ReactApplicationContext reactContext;

    public RNMediaManipulatorModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
    return "RNMediaManipulator";
  }

    @ReactMethod
    public void mergeImages(ReadableMap backgroundObj, ReadableArray imageObjs, Promise promise) {
        String fileExtension = "jpeg";
        if (backgroundObj.hasKey("extension")) fileExtension = backgroundObj.getString("extension");
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = false;
        options.inDither = false;
        options.inScaled = false;
        options.inPreferredConfig = Bitmap.Config.ARGB_8888;
        try {
            URL backgroundImageUrl = new URL(backgroundObj.getString("uri"));
            Integer backgroundWidth = (int) backgroundObj.getDouble("width");
            Integer backgroundHeight = (int) backgroundObj.getDouble("height");
            Bitmap backgroundImage = BitmapFactory.decodeStream(backgroundImageUrl.openConnection().getInputStream(), null, options);
            Integer originalScale = backgroundWidth/backgroundImage.getWidth();
            Bitmap scaledBackgroundImage = Bitmap.createScaledBitmap(backgroundImage, backgroundWidth, backgroundHeight, false);
            Bitmap backgroundCanvasImage = Bitmap.createBitmap(backgroundWidth, backgroundHeight, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(backgroundCanvasImage);
            canvas.drawBitmap(scaledBackgroundImage, new Matrix(), null);

            for (int i = 0; i < imageObjs.size(); i++) {
                ReadableMap imageObj = imageObjs.getMap(i);
                Double positionX = imageObj.getDouble("x");
                Double positionY = imageObj.getDouble("y");
                if (positionX == null) positionX = (double) imageObj.getInt("x");
                if (positionY == null) positionY = (double) imageObj.getInt("y");
                String imageUri = imageObj.getString("uri");
                Log.v(TAG, "This is the imageUri: " + imageUri + ", the positionX: " + positionX + ", and the positionY: " + positionY);
                Bitmap picture;
                if (imageUri.indexOf("data:") == 0 && imageUri.indexOf("base64") != -1) {
                    String pureBase64 = imageUri.substring(imageUri.indexOf(',') + 1);
                    byte[] decodedBytes = Base64.decode(pureBase64, Base64.DEFAULT);
                    picture = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);
                } else {
                    URL imageUrl = new URL(imageUri);
                    picture = BitmapFactory.decodeStream(imageUrl.openConnection().getInputStream(), null, options);
                }

                Double scale = 1.0;
                if (imageObj.hasKey("scale")) {
                    scale = imageObj.getDouble("scale");
                    if (scale == null) scale = (double) imageObj.getInt("scale");

                }
                Double imageWidth;
                Double imageHeight;
                if (imageObj.hasKey("width") && imageObj.hasKey("height")) {
                    imageWidth = imageObj.getDouble("width");
                    imageHeight = imageObj.getDouble("height");
                    if (imageWidth == null) imageWidth = (double) imageObj.getInt("width");
                    if (imageHeight == null) imageHeight = (double) imageObj.getInt("height");
                } else {
                    imageWidth = (double) picture.getWidth();
                    imageHeight = (double) picture.getHeight();
                }

                Matrix matrix = new Matrix();
                if (imageObj.hasKey("rotate")) {
                    Double rotate = Double.parseDouble(imageObj.getString("rotate").replace("deg", ""));
                    matrix.postRotate(rotate.floatValue());
                }

                matrix.postScale(scale.floatValue(), scale.floatValue());

                picture = Bitmap.createScaledBitmap(picture, Math.round(imageWidth.floatValue()*scale.floatValue()), Math.round(imageHeight.floatValue()*scale.floatValue()), true);
                picture = Bitmap.createBitmap(picture, 0, 0, picture.getWidth(), picture.getHeight(), matrix, true);

                Paint paint = new Paint();
                paint.setAntiAlias(true);
                paint.setFilterBitmap(true);
                paint.setDither(true);
                canvas.drawBitmap(picture, (positionX.floatValue() + imageWidth.floatValue()/2 - picture.getWidth()/2), (positionY.floatValue() + imageHeight.floatValue()/2 - picture.getHeight()/2), paint);
            }



            String timestamp = new SimpleDateFormat("yyyyMMddHHmmss",
                    java.util.Locale.getDefault()).format(new Date());
            String fileLocation = this.reactContext.getCacheDir().getAbsolutePath() + "/IMG_" + timestamp + "." + fileExtension;
            FileOutputStream outputStream = new FileOutputStream(fileLocation);
            backgroundCanvasImage.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);
            backgroundCanvasImage = null;
            promise.resolve(fileLocation);
        } catch (java.io.IOException e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            promise.reject("ERROR", e);
        }


    }

}
