package com.huseyinasir.otomotiv

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.shortcuts/handler"
    private var pendingShortcut: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getShortcut") {
                result.success(pendingShortcut)
                pendingShortcut = null
            } else {
                result.notImplemented()
            }
        }
        
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        val data = intent?.data
        if (data != null && data.scheme == "app" && data.host == "shortcut") {
            pendingShortcut = data.lastPathSegment
        }
    }
}
