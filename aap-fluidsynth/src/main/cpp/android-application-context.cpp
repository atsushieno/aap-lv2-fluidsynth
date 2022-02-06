#include <android/log.h>
#include "android-application-context.h"

// Android-specific API. Not sure if we would like to keep it in the host API - it is for plugins.
JavaVM *android_vm{nullptr};
jobject application_context{nullptr};

extern "C" JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* reserved) {
	android_vm = vm;
	return JNI_VERSION_1_6;
}

extern "C"
JNIEXPORT void JNICALL
Java_org_androidaudioplugin_aap_1fluidsynth_JNIInitializer_setApplicationContext(
        JNIEnv * env, jobject obj, jobject appContext) {
    application_context = env->NewGlobalRef((jobject) appContext);
}

JavaVM *get_android_jvm() { return android_vm; }

void unset_application_context(JNIEnv *env) {
    if (application_context)
        env->DeleteGlobalRef(application_context);
}

AAssetManager *get_android_asset_manager(JNIEnv* env) {
    if (!application_context)
        return nullptr;
    auto appClass = env->GetObjectClass(application_context);
    auto getAssetsID = env->GetMethodID(appClass, "getAssets", "()Landroid/content/res/AssetManager;");
    auto assetManagerJ = env->CallObjectMethod(application_context, getAssetsID);
    return AAssetManager_fromJava(env, assetManagerJ);
}
