package expo.modules.gaodemap.modules

import android.content.Context
import android.util.Log
import com.amap.api.location.AMapLocationClient
import com.amap.api.maps.MapsInitializer

/**
 * SDK 初始化管理器
 */
object SDKInitializer {
    private const val TAG = "SDKInitializer"

    /**
     * 初始化高德地图和定位 SDK
     */
    fun initSDK(context: Context, androidKey: String) {
        try {
            Log.d(TAG, "开始初始化 SDK...")
            
            // 更新地图隐私合规
            MapsInitializer.updatePrivacyShow(context, true, true)
            MapsInitializer.updatePrivacyAgree(context, true)
            MapsInitializer.setApiKey(androidKey)
            Log.d(TAG, "地图 SDK 初始化完成")
            
            // 更新定位隐私合规
            AMapLocationClient.updatePrivacyShow(context, true, true)
            AMapLocationClient.updatePrivacyAgree(context, true)
            AMapLocationClient.setApiKey(androidKey)
            Log.d(TAG, "定位 SDK 初始化完成")
            
        } catch (e: Exception) {
            Log.e(TAG, "SDK 初始化失败", e)
            throw Exception("SDK 初始化失败: ${e.message}")
        }
    }

    /**
     * 获取 SDK 版本
     */
    fun getVersion(): String {
        return MapsInitializer.getVersion()
    }
}
