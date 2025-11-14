import ExpoModulesCore
import MAMapKit

/**
 * 圆形覆盖物视图
 * 
 * 负责:
 * - 在地图上绘制圆形
 * - 管理圆形的样式(填充色、边框色、边框宽度)
 * - 响应属性变化并更新渲染
 */
class CircleView: ExpoView {
    /// 圆心坐标
    var circleCenter: [String: Double] = [:]
    /// 半径(米)
    var radius: Double = 0
    /// 填充颜色
    var fillColor: Any?
    /// 边框颜色
    var strokeColor: Any?
    /// 边框宽度
    var strokeWidth: Float = 0
    
    /// 地图视图弱引用
    private var mapView: MAMapView?
    /// 圆形覆盖物对象
    var circle: MACircle?
    /// 圆形渲染器
    private var renderer: MACircleRenderer?
    
    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        circle = MACircle()
    }
    
    /**
     * 设置地图实例
     * @param map 地图视图
     */
    func setMap(_ map: MAMapView) {
        self.mapView = map
        if let circle = circle {
            map.add(circle)
        }
    }
    
    /**
     * 更新圆形覆盖物
     */
    private func updateCircle() {
        guard let latitude = circleCenter["latitude"],
              let longitude = circleCenter["longitude"] else { return }
        circle?.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        circle?.radius = radius
    }
    
    /**
     * 获取圆形渲染器
     * @return 渲染器实例
     */
    func getRenderer() -> MAOverlayRenderer {
        if renderer == nil, let circle = circle {
            renderer = MACircleRenderer(circle: circle)
            renderer?.fillColor = ColorParser.parseColor(fillColor) ?? UIColor.clear
            renderer?.strokeColor = ColorParser.parseColor(strokeColor) ?? UIColor.clear
            renderer?.lineWidth = CGFloat(strokeWidth)
        }
        return renderer!
    }
    
    /**
     * 设置中心点
     * @param center 中心点坐标 {latitude, longitude}
     */
    func setCenter(_ center: [String: Double]) {
        circleCenter = center
        renderer = nil
        updateCircle()
    }
    
    /**
     * 设置半径
     * @param radius 半径(米)
     */
    func setRadius(_ radius: Double) {
        self.radius = radius
        renderer = nil
        updateCircle()
    }
    
    /**
     * 设置填充颜色
     * @param color 颜色值
     */
    func setFillColor(_ color: Any?) {
        fillColor = color
        renderer = nil
        updateCircle()
    }
    
    /**
     * 设置边框颜色
     * @param color 颜色值
     */
    func setStrokeColor(_ color: Any?) {
        strokeColor = color
        renderer = nil
        updateCircle()
    }
    
    /**
     * 设置边框宽度
     * @param width 宽度值
     */
    func setStrokeWidth(_ width: Float) {
        strokeWidth = width
        renderer = nil
        updateCircle()
    }
    
    /**
     * 析构时移除圆形
     */
    deinit {
        if let mapView = mapView, let circle = circle {
            mapView.remove(circle)
        }
    }
}
