package com.release.testlet;

import org.tensorflow.lite.Interpreter;

import java.util.Arrays;

import android.content.Intent;
import android.os.Bundle;
import java.util.ArrayList;
import java.lang.Integer;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.List;

import android.content.res.AssetFileDescriptor;

import com.google.common.primitives.Floats;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "ondeviceML";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(

                (MethodCall call, Result result) -> {
                    if (call.method.equals("AllCloud")) {

                        ArrayList<ArrayList<Integer>> bruh = new ArrayList<ArrayList<Integer>>();

                        bruh = call.argument("arg");

                        float [][] args = new float[bruh.size()][22];

                        for(int i = 0; i<bruh.size(); i++)
                            for(int j = 0; j<22; j++)
                                args[i][j] = bruh.get(i).get(j);


                        float[][] prediction = predictData(args, "AllCloud");

                        List<List<Float>> modifiedOutput =  new ArrayList<>();

                        for (float[] floats : prediction) {
                            modifiedOutput.add(Floats.asList(floats));
                        }

                        if (prediction != null) {
                            result.success(modifiedOutput);
                        } else {
                            result.error("UNAVAILABLE", "prediction  not available.", null);
                        }
                    } else {
                        result.notImplemented();
                    }}
        );

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(

                (MethodCall call, Result result) -> {
                        if (call.method.equals("predictData")) {

                            ArrayList<ArrayList<Integer>> bruh = new ArrayList<ArrayList<Integer>>();

                            bruh = call.argument("arg");

                            float [][] args = new float[bruh.size()][14];

                            for(int i = 0; i<bruh.size(); i++)
                                for(int j = 0; j<14; j++)
                                    args[i][j] = bruh.get(i).get(j);


                            float[][] prediction = predictData(args, "Vertmodel");

                            List<List<Float>> modifiedOutput =  new ArrayList<>();

                            for (float[] floats : prediction) {
                                modifiedOutput.add(Floats.asList(floats));
                            }

                            if (prediction != null) {
                                result.success(modifiedOutput);
                            } else {
                                result.error("UNAVAILABLE", "prediction  not available.", null);
                            }
                        } else {
                            result.notImplemented();
                        }}
                );
    }

    // This method interact with our model and makes prediction returning value of "0" or "1".
    float[][] predictData(float[][] input, String model)
    {


        Interpreter tflite;
        //System.out.println(input_data);
        try {
            tflite = new Interpreter(loadModelFile(model), null);
        } catch (Exception e) {
            System.out.println(e.toString());
            tflite = null;
        }

        float [][] output = new float[input.length][3];

        for(int i = 0; i<input.length; i++)
            for(int j = 0; j<3; j++)
                output[i][j] = 0;

        //System.out.println(Arrays.deepToString(input));

        //System.out.println(output.length);


        tflite.run(input,output);

        //System.out.println(Arrays.deepToString(output));

//        int [] result = new int[input.length];
//
//        for(int i = 0; i < input.length; i++){
//
//        }
//        System.out.println(result);

        return output;
    }


    // method to load tflite file from device

    private MappedByteBuffer loadModelFile(String model) throws Exception {
        //System.out.println(Arrays.deepToString(this.getAssets().list( "flutter_assets/assets" )));
        AssetFileDescriptor fileDescriptor = this.getAssets().openFd("flutter_assets/assets/"+model+".tflite");
        FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
        FileChannel fileChannel = inputStream.getChannel();
        long startOffset = fileDescriptor.getStartOffset();
        long declaredLength = fileDescriptor.getDeclaredLength();
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
    }

}