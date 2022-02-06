#include <jni.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <android/binder_ibinder.h>

JavaVM *get_android_jvm();
void unset_application_context(JNIEnv *env);
AAssetManager *get_android_asset_manager(JNIEnv *env);
