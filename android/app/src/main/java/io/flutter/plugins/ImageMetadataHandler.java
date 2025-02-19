package io.flutter.plugins;

import android.content.Context;
import android.media.ExifInterface;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;



/** ImageMetadataHandler */
public class ImageMetadataHandler implements FlutterPlugin, MethodChannel.MethodCallHandler {
    private MethodChannel channel;
    private Context mContext = null;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        mContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "image_metadata_channel");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("addImageMetadata")) {
            byte[] imageBytes = call.argument("imageBytes");
            Map<String, Object> metadata = call.argument("metadata");

            if (imageBytes != null && metadata != null) {
                try {
                    byte[] resultBytes = addMetadata(imageBytes, metadata);
                    result.success(resultBytes);
                } catch (Exception e) {
                    result.error("ERROR", e.getMessage(), null);
                }
            } else {
                result.error("INVALID_ARGUMENTS", "Missing required arguments", null);
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private byte[] addMetadata(byte[] imageBytes, Map<String, Object> metadata) throws IOException {
        File tempFile = null;
        try {
            // 创建临时文件
            tempFile = File.createTempFile("temp_", ".jpg");
            try (FileOutputStream fos = new FileOutputStream(tempFile)) {
                fos.write(imageBytes);
            }

            // 添加EXIF信息
            ExifInterface exif = new ExifInterface(tempFile.getAbsolutePath());

            // 写入基本信息
            if (metadata.containsKey("artist")) {
                exif.setAttribute(ExifInterface.TAG_ARTIST, metadata.get("artist").toString());
            }
            if (metadata.containsKey("copyright")) {
                exif.setAttribute(ExifInterface.TAG_COPYRIGHT, metadata.get("copyright").toString());
            }
            if (metadata.containsKey("software")) {
                exif.setAttribute(ExifInterface.TAG_SOFTWARE, metadata.get("software").toString());
            }
            if (metadata.containsKey("datetime")) {
                exif.setAttribute(ExifInterface.TAG_DATETIME, metadata.get("datetime").toString());
            }
            if (metadata.containsKey("width")) {
                exif.setAttribute(ExifInterface.TAG_IMAGE_WIDTH, metadata.get("width").toString());
            }
            if (metadata.containsKey("height")) {
                exif.setAttribute(ExifInterface.TAG_IMAGE_LENGTH, metadata.get("height").toString());
            }

            // 写入自定义信息
            List<String> reservedKeys = Arrays.asList("artist", "copyright", "software", "datetime");
            StringBuilder customComments = new StringBuilder();
            
            for (Map.Entry<String, Object> entry : metadata.entrySet()) {
                if (!reservedKeys.contains(entry.getKey())) {
                    if (customComments.length() > 0) {
                        customComments.append("\n");
                    }
                    customComments.append(entry.getKey())
                               .append(": ")
                               .append(entry.getValue().toString());
                }
            }

            if (customComments.length() > 0) {
                exif.setAttribute(ExifInterface.TAG_USER_COMMENT, customComments.toString());
            }

            // 保存EXIF信息
            exif.saveAttributes();

            // 读取处理后的文件
            byte[] resultBytes = new byte[(int) tempFile.length()];
            try (java.io.FileInputStream fis = new java.io.FileInputStream(tempFile)) {
                fis.read(resultBytes);
            }
            return resultBytes;

        } finally {
            // 清理临时文件
            if (tempFile != null && tempFile.exists()) {
                tempFile.delete();
            }
        }
    }
} 