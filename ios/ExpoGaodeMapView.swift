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
    let onMarkerPress = EventDispatcher()
    let onMarkerDragStart = EventDispatcher()
    let onMarkerDrag = EventDispatcher()
    let onMarkerDragEnd = EventDispatcher()
    let onCirclePress = EventDispatcher()
    
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
    /// 是否正在处理 annotation 选择事件
    private var isHandlingAnnotationSelect = false
    
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
        
        // 设置 Circle 点击回调
        overlayManager.onCirclePress = { [weak self] event in
            self?.onCirclePress(event)
        }
        
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
        
        print("🔧 添加子视图: \(type(of: view))")
        
        if let markerView = view as? MarkerView {
            print("✅ 识别为 MarkerView")
            markerView.setMap(mapView)
        } else if let circleView = view as? CircleView {
            print("✅ 识别为 CircleView")
            circleView.setMap(mapView)
        } else if let polylineView = view as? PolylineView {
            print("✅ 识别为 PolylineView")
            polylineView.setMap(mapView)
        } else if let polygonView = view as? PolygonView {
            print("✅ 识别为 PolygonView")
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
        // 如果正在处理 annotation 选择，跳过地图点击事件
        if isHandlingAnnotationSelect {
            isHandlingAnnotationSelect = false
            return
        }
        
        // 检查是否点击了圆形 (声明式 CircleView)
        if checkCirclePress(at: coordinate) {
            return
        }
        
        // 检查是否点击了圆形 (命令式 API)
        if overlayManager.checkCirclePress(at: coordinate) {
            return
        }
        
        onMapPress(["latitude": coordinate.latitude, "longitude": coordinate.longitude])
    }
    
    /**
     * 检查点击位置是否在圆形内
     */
    private func checkCirclePress(at coordinate: CLLocationCoordinate2D) -> Bool {
        let circleViews = subviews.compactMap { $0 as? CircleView }
        print("🔍 检查圆形点击 - 找到 \(circleViews.count) 个 CircleView")
        
        for circleView in circleViews {
            guard let circle = circleView.circle else {
                print("⚠️ CircleView 没有 circle 对象")
                continue
            }
            
            let circleCenter = circle.coordinate
            let distance = calculateDistance(from: coordinate, to: circleCenter)
            print("📍 圆心: (\(circleCenter.latitude), \(circleCenter.longitude)), 半径: \(circle.radius)m, 距离: \(distance)m")
            
            if distance <= circle.radius {
                print("✅ 点击在圆形内，触发 onPress")
                circleView.onPress([
                    "latitude": coordinate.latitude,
                    "longitude": coordinate.longitude
                ])
                return true
            }
        }
        print("❌ 点击不在任何圆形内")
        return false
    }
    
    /**
     * 计算两点间距离(米)
     */
    private func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
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
            guard let props = overlayManager.getMarkerProps(for: annotation) else {
                return nil
            }
            
            let iconUri = props["icon"] as? String
            let iconWidth = props["iconWidth"] as? Double ?? 40
            let iconHeight = props["iconHeight"] as? Double ?? 40
            let pinColor = props["pinColor"] as? String ?? "red"
            let draggable = props["draggable"] as? Bool ?? false
            
            // 如果有自定义图标，使用 MAAnnotationView
            if let iconUri = iconUri, !iconUri.isEmpty {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom_marker")
                if annotationView == nil {
                    annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: "custom_marker")
                }
                annotationView?.annotation = annotation
                annotationView?.canShowCallout = true
                annotationView?.isDraggable = draggable
                
                // 加载图标
                loadMarkerIcon(iconUri: iconUri) { image in
                    if let img = image {
                        // 调整图标大小
                        let size = CGSize(width: iconWidth, height: iconHeight)
                        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                        img.draw(in: CGRect(origin: .zero, size: size))
                        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                        annotationView?.image = resizedImage
                        // 设置中心点偏移，使标注底部中间点成为经纬度对应点
                        annotationView?.centerOffset = CGPoint(x: 0, y: -iconHeight / 2)
                    }
                }
                
                return annotationView
            }
            
            // 使用大头针样式
            guard let pinView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: "pin_marker") else {
                return nil
            }
            pinView.canShowCallout = true
            pinView.animatesDrop = true
            pinView.isDraggable = draggable
            
            // 设置大头针颜色
            if pinColor == "green" {
                pinView.pinColor = .green
            } else if pinColor == "purple" {
                pinView.pinColor = .purple
            } else {
                pinView.pinColor = .red
            }
            
            return pinView
        }
        return nil
    }
    
    /**
     * 创建覆盖物渲染器
     * 优先使用子视图的渲染器,否则使用 OverlayManager 的渲染器
     */
    public func mapView(_ mapView: MAMapView, rendererFor overlay: MAOverlay) -> MAOverlayRenderer {
        for subview in subviews {
            if let circleView = subview as? CircleView, let circle = circleView.circle, circle === overlay {
                return circleView.getRenderer()
            } else if let polylineView = subview as? PolylineView, polylineView.polyline === overlay {
                return polylineView.getRenderer()
            } else if let polygonView = subview as? PolygonView, polygonView.polygon === overlay {
                return polygonView.getRenderer()
            }
        }
        
        return overlayManager.getRenderer(for: overlay) ?? MAOverlayRenderer(overlay: overlay)
    }
    
    /**
     * 标注点击事件
     */
    public func mapView(_ mapView: MAMapView, didSelect view: MAAnnotationView) {
        guard let annotation = view.annotation, !annotation.isKind(of: MAUserLocation.self) else {
            return
        }
        
        // 标记正在处理 annotation 选择，阻止地图点击事件
        isHandlingAnnotationSelect = true
        
        // 查找对应的 markerId
        if let markerId = overlayManager.getMarkerId(for: annotation) {
            onMarkerPress([
                "markerId": markerId,
                "latitude": annotation.coordinate.latitude,
                "longitude": annotation.coordinate.longitude
            ])
        }
        
        // 不要立即取消选中，让气泡有机会显示
        // 用户点击地图其他地方时会自动取消选中
    }
    
    /**
     * 标注拖拽状态变化
     */
    public func mapView(_ mapView: MAMapView, annotationView view: MAAnnotationView, didChange newState: MAAnnotationViewDragState, fromOldState oldState: MAAnnotationViewDragState) {
        guard let annotation = view.annotation else { return }
        
        if let markerId = overlayManager.getMarkerId(for: annotation) {
            let coord = annotation.coordinate
            let event: [String: Any] = [
                "markerId": markerId,
                "latitude": coord.latitude,
                "longitude": coord.longitude
            ]
            
            switch newState {
            case .starting:
                onMarkerDragStart(event)
            case .dragging:
                onMarkerDrag(event)
            case .ending, .canceling:
                onMarkerDragEnd(event)
            default:
                break
            }
        }
    }
    
    /**
     * 加载标记图标
     * @param iconUri 图标 URI (支持 http/https/file/本地资源)
     * @param completion 加载完成回调
     */
    private func loadMarkerIcon(iconUri: String, completion: @escaping (UIImage?) -> Void) {
        if iconUri.hasPrefix("http://") || iconUri.hasPrefix("https://") {
            // 网络图片
            guard let url = URL(string: iconUri) else {
                completion(nil)
                return
            }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                DispatchQueue.main.async { completion(image) }
            }.resume()
        } else if iconUri.hasPrefix("file://") {
            // 本地文件
            let path = String(iconUri.dropFirst(7))
            completion(UIImage(contentsOfFile: path))
        } else {
            // 资源文件名
            completion(UIImage(named: iconUri))
        }
    }
}
