package org.androidaudioplugin.aap_fluidsynth

import android.content.Context
import androidx.startup.Initializer

class JNIInitializer : Initializer<Unit> {

    external fun setApplicationContext(ctx: Context)

    override fun create(context: Context) {
        System.loadLibrary("aap-fluidsynth")
        setApplicationContext(context.applicationContext)
    }

    override fun dependencies(): MutableList<Class<out Initializer<*>>> {
        return mutableListOf<Class<out Initializer<*>>>()
    }
}
