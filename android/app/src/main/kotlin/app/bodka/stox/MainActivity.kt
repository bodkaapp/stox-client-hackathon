package app.bodka.stox

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.bodka.stox/volume"
    private var isVolumeListenerActive = false
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "enableVolumeListener") {
                isVolumeListenerActive = true
                result.success(null)
            } else if (call.method == "disableVolumeListener") {
                isVolumeListenerActive = false
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (isVolumeListenerActive) {
            if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN || keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
                // Determine direction if needed, but for shutter just trigger
                methodChannel?.invokeMethod("onVolumeBtnPressed", null)
                return true // Consume the event (prevent volume change & UI)
            }
        }
        return super.onKeyDown(keyCode, event)
    }
}
