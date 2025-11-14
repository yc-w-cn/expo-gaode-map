import ExpoModulesCore
import MAMapKit

/**
 * 高德地图视图组件
 * 
 * 负责:
 * - 地图视图的创建和管理
 * - 相机控制和手势交互
 * - 覆盖物的添加和管理
 * - 地图事件的派发
 */
class ExpoGaodeMapView: ExpoView, MAMapViewDelegate {
    // MARK: - 属性
    
    /// 地图类型 (0:标准 1:卫星 2:夜间 3:导航)
    var mapType: Int = 0
    /// 初始相机位置
    var initialCameraPosition: [String: Any]?
    /// 是否显示缩放控件
    var showsZoomControls: Bool = true
    /// 是否显示指南针
    var showsCompass: Bool = true
    /// 是否显示比例尺
    var showsScale: Bool = true
    /// 是否启用缩放手势
    var isZoomEnabled: Bool = true
    /// 是否启用滚动手势
    var isScrollEnabled: Bool = true
    /// 是否启用旋转手势
    var isRotateEnabled: Bool = true
    /// 是否启用倾斜手势
    var isTiltEnabled: Bool = true
    /// 是否显示用户位置
    var showsUserLocation: Bool = false
    /// 是否跟随用户位置
    var followUserLocation: Bool = false {
        didSet {
            if showsUserLocation {
                uiManager?.setShowsUserLocation(true, followUser: followUserLocation)
            }
        }
    }
    /// 用户位置样式配置
    var userLocationRepresentation: [String: Any]?
    /// 是否显示交通路况
    var showsTraffic: Bool = false
    /// 是否显示建筑物
    var showsBuildings: Bool = false
    /// 是否显示室内地图
    var showsIndoorMap: Bool = false
    /// 最大缩放级别
    var maxZoomLevel: CGFloat = 20
    /// 最小缩放级别
    var minZoomLevel: CGFloat = 3
    
    // MARK: - 事件派发器
    
    let onMapPress = EventDispatcher()
    let onMapLongPress = EventDispatcher()
    let onLoad = EventDispatcher()
    
    // MARK: - 私有属性
    
    /// 高德地图视图实例
    private var mapView: MAMapView!
    /// 相机管理器
    private var cameraManager: CameraManager!
    /// UI 管理器
    private var uiManager: UIManager!
    /// 覆盖物管理器
    private var overlayManager: OverlayManager!
    /// 地图是否已加载完成
    private var isMapLoaded = false
    
    // MARK: - 初始化
    
    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        
        // 确保隐私合规已设置
        MAMapView.updatePrivacyAgree(.didAgree)
        MAMapView.updatePrivacyShow(.didShow, privacyInfo: .didContain)
        
        mapView = MAMapView(frame: bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(mapView)
        
        cameraManager = CameraManager(mapView: mapView)
        uiManager = UIManager(mapView: mapView)
        overlayManager = OverlayManager(mapView: mapView)
        
        setupDefaultConfig()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = bounds
    }
    
    /**
     * 添加子视图时自动连接到地图
     * 将地图实例传递给覆盖物子视图
     */
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        if let markerView = view as? MarkerView {
            markerView.setMap(mapView)
        } else if let circleView = view as? CircleView {
            circleView.setMap(mapView)
        } else if let polylineView = view as? PolylineView {
            polylineView.setMap(mapView)
        } else if let polygonView = view as? PolygonView {
            polygonView.setMap(mapView)
        } else if let heatMapView = view as? HeatMapView {
            heatMapView.setMap(mapView)
        } else if let multiPointView = view as? MultiPointView {
            multiPointView.setMap(mapView)
        } else if let clusterView = view as? ClusterView {
            clusterView.setMap(mapView)
        }
    }
    
    /**
     * 设置默认配置
     */
    private func setupDefaultConfig() {
        uiManager.setMapType(0)
        uiManager.setShowsScale(showsScale)
        uiManager.setShowsCompass(showsCompass)
        uiManager.setZoomEnabled(isZoomEnabled)
        uiManager.setScrollEnabled(isScrollEnabled)
        uiManager.setRotateEnabled(isRotateEnabled)
        uiManager.setTiltEnabled(isTiltEnabled)
        uiManager.setShowsUserLocation(showsUserLocation, followUser: followUserLocation)
    }
    
    /**
     * 应用所有属性配置
     * 在 Props 更新时调用
     */
    func applyProps() {
        uiManager.setMapType(mapType)
        
        if let position = initialCameraPosition, isMapLoaded {
            cameraManager.setInitialCameraPosition(position)
        }
        
        uiManager.setShowsScale(showsScale)
        uiManager.setShowsCompass(showsCompass)
        uiManager.setZoomEnabled(isZoomEnabled)
        uiManager.setScrollEnabled(isScrollEnabled)
        uiManager.setRotateEnabled(isRotateEnabled)
        uiManager.setTiltEnabled(isTiltEnabled)
        uiManager.setShowsUserLocation(showsUserLocation, followUser: followUserLocation)
        uiManager.setShowsTraffic(showsTraffic)
        uiManager.setShowsBuildings(showsBuildings)
        uiManager.setShowsIndoorMap(showsIndoorMap)
    }
    
    // MARK: - 缩放控制
    
    func setMaxZoom(_ maxZoom: Double) {
        cameraManager.setMaxZoomLevel(CGFloat(maxZoom))
    }
    
    func setMinZoom(_ minZoom: Double) {
        cameraManager.setMinZoomLevel(CGFloat(minZoom))
    }
    
    // MARK: - 相机控制
    
    func moveCamera(position: [String: Any], duration: Int) {
        cameraManager.moveCamera(position: position, duration: duration)
    }
    
    func getLatLng(point: [String: Double]) -> [String: Double] {
        return cameraManager.getLatLng(point: point)
    }
    
    func setCenter(center: [String: Double], animated: Bool) {
        cameraManager.setCenter(center: center, animated: animated)
    }
    
    func setZoom(zoom: Double, animated: Bool) {
        cameraManager.setZoomLevel(zoom: CGFloat(zoom), animated: animated)
    }
    
    func getCameraPosition() -> [String: Any] {
        return cameraManager.getCameraPosition()
    }
    
    // MARK: - 覆盖物管理
    
    func addCircle(id: String, props: [String: Any]) {
        overlayManager.addCircle(id: id, props: props)
    }
    
    func removeCircle(id: String) {
        overlayManager.removeCircle(id: id)
    }
    
    func updateCircle(id: String, props: [String: Any]) {
        overlayManager.updateCircle(id: id, props: props)
    }
    
    func addMarker(id: String, props: [String: Any]) {
        overlayManager.addMarker(id: id, props: props)
    }
    
    func removeMarker(id: String) {
        overlayManager.removeMarker(id: id)
    }
    
    func updateMarker(id: String, props: [String: Any]) {
        overlayManager.updateMarker(id: id, props: props)
    }
    
    func addPolyline(id: String, props: [String: Any]) {
        overlayManager.addPolyline(id: id, props: props)
    }
    
    func removePolyline(id: String) {
        overlayManager.removePolyline(id: id)
    }
    
    func updatePolyline(id: String, props: [String: Any]) {
        overlayManager.updatePolyline(id: id, props: props)
    }
    
    func addPolygon(id: String, props: [String: Any]) {
        overlayManager.addPolygon(id: id, props: props)
    }
    
    func removePolygon(id: String) {
        overlayManager.removePolygon(id: id)
    }
    
    func updatePolygon(id: String, props: [String: Any]) {
        overlayManager.updatePolygon(id: id, props: props)
    }
    
    // MARK: - 图层控制
    
    func setShowsTraffic(_ show: Bool) {
        showsTraffic = show
        uiManager.setShowsTraffic(show)
    }
    
    func setShowsBuildings(_ show: Bool) {
        showsBuildings = show
        uiManager.setShowsBuildings(show)
    }
    
    func setShowsIndoorMap(_ show: Bool) {
        showsIndoorMap = show
        uiManager.setShowsIndoorMap(show)
    }
    
    func setFollowUserLocation(_ follow: Bool) {
        followUserLocation = follow
        uiManager.setShowsUserLocation(showsUserLocation, followUser: follow)
    }
    
    func setShowsUserLocation(_ show: Bool) {
        showsUserLocation = show
        uiManager.setShowsUserLocation(show, followUser: followUserLocation)
        if show {
            applyUserLocationStyle()
        }
    }
    
    func setUserLocationRepresentation(_ config: [String: Any]) {
        userLocationRepresentation = config
        if showsUserLocation {
            uiManager.setUserLocationRepresentation(config)
        }
    }
    
    /**
     * 应用用户位置样式
     */
    private func applyUserLocationStyle() {
        guard let config = userLocationRepresentation else { return }
        uiManager.setUserLocationRepresentation(config)
    }
    
    /**
     * 析构函数 - 清理资源
     */
    deinit {
        mapView?.delegate = nil
        overlayManager?.clear()
    }
}

// MARK: - MAMapViewDelegate

extension ExpoGaodeMapView {
    /**
     * 地图加载完成回调
     */
    public func mapViewDidFinishLoadingMap(_ mapView: MAMapView) {
        guard !isMapLoaded else { return }
        isMapLoaded = true
        if let position = initialCameraPosition {
            cameraManager.setInitialCameraPosition(position)
        }
        onLoad(["loaded": true])
    }
    
    /**
     * 地图单击事件
     */
    public func mapView(_ mapView: MAMapView, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        onMapPress(["latitude": coordinate.latitude, "longitude": coordinate.longitude])
    }
    
    /**
     * 地图长按事件
     */
    public func mapView(_ mapView: MAMapView, didLongPressedAt coordinate: CLLocationCoordinate2D) {
        onMapLongPress(["latitude": coordinate.latitude, "longitude": coordinate.longitude])
    }
    
    /**
     * 创建标注视图
     * 定位蓝点返回 nil 使用系统默认样式
     */
    public func mapView(_ mapView: MAMapView, viewFor annotation: MAAnnotation) -> MAAnnotationView? {
        if annotation.isKind(of: MAUserLocation.self) {
            return nil
        }
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let identifier = "marker"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if view == nil {
                view = MAPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            view?.canShowCallout = true
            return view
        }
        return nil
    }
    
    /**
     * 创建覆盖物渲染器
     * 优先使用子视图的渲染器,否则使用 OverlayManager 的渲染器
     */
    public func mapView(_ mapView: MAMapView, rendererFor overlay: MAOverlay) -> MAOverlayRenderer {
        for subview in subviews {
            if let circleView = subview as? CircleView, circleView.circle === overlay {
                return circleView.getRenderer()
            } else if let polylineView = subview as? PolylineView, polylineView.polyline === overlay {
                return polylineView.getRenderer()
            } else if let polygonView = subview as? PolygonView, polygonView.polygon === overlay {
                return polygonView.getRenderer()
            }
        }
        
        return overlayManager.getRenderer(for: overlay) ?? MAOverlayRenderer(overlay: overlay)
    }
}
