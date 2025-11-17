import MAMapKit

/**
 * 覆盖物管理器
 * 
 * 负责:
 * - 管理地图覆盖物(圆形、折线、多边形)
 * - 管理标记点(Marker)
 * - 处理覆盖物样式和渲染
 * - 支持纹理贴图
 */
class OverlayManager {
    /// 地图视图弱引用
    private weak var mapView: MAMapView?
    /// 覆盖物字典 (id -> overlay)
    private var overlays: [String: MAOverlay] = [:]
    /// 覆盖物样式字典 (id -> style)
    private var overlayStyles: [String: [String: Any]] = [:]
    /// 标记点字典 (id -> annotation)
    private var annotations: [String: MAPointAnnotation] = [:]
    /// 标记点属性字典 (id -> props)
    private var markerProps: [String: [String: Any]] = [:]
    /// Circle 点击回调
    var onCirclePress: (([String: Any]) -> Void)?
    /// Circle ID 映射 (overlay -> id)
    private var circleIdMap: [MACircle: String] = [:]
    
    /**
     * 初始化覆盖物管理器
     * @param mapView 地图视图实例
     */
    init(mapView: MAMapView) {
        self.mapView = mapView
    }
    
    /**
     * 检查点击位置是否在圆形内
     */
    func checkCirclePress(at coordinate: CLLocationCoordinate2D) -> Bool {
        for (circle, circleId) in circleIdMap {
            let circleCenter = circle.coordinate
            let fromLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let toLocation = CLLocation(latitude: circleCenter.latitude, longitude: circleCenter.longitude)
            let distance = fromLocation.distance(from: toLocation)
            
            if distance <= circle.radius {
                onCirclePress?([
                    "circleId": circleId,
                    "latitude": coordinate.latitude,
                    "longitude": coordinate.longitude
                ])
                return true
            }
        }
        return false
    }
    
    // MARK: - Circle 圆形
    
    /**
     * 添加圆形覆盖物
     * @param id 圆形唯一标识
     * @param props 圆形属性(center, radius, fillColor, strokeColor, strokeWidth)
     */
    func addCircle(id: String, props: [String: Any]) {
        guard let mapView = mapView,
              let center = props["center"] as? [String: Double],
              let latitude = center["latitude"],
              let longitude = center["longitude"],
              let radius = props["radius"] as? Double else { return }
        
        let circle = MACircle(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius)
        overlayStyles[id] = props
        overlays[id] = circle
        circleIdMap[circle!] = id
        mapView.add(circle!)
    }
    
    /**
     * 移除圆形覆盖物
     * @param id 圆形唯一标识
     */
    func removeCircle(id: String) {
        guard let mapView = mapView, let circle = overlays[id] as? MACircle else { return }
        mapView.remove(circle)
        overlays.removeValue(forKey: id)
        overlayStyles.removeValue(forKey: id)
        circleIdMap.removeValue(forKey: circle)
    }
    
    /**
     * 更新圆形覆盖物
     * @param id 圆形唯一标识
     * @param props 新的圆形属性
     */
    func updateCircle(id: String, props: [String: Any]) {
        removeCircle(id: id)
        addCircle(id: id, props: props)
    }
    
    // MARK: - Marker 标记点
    
    /**
     * 添加标记点
     * @param id 标记点唯一标识
     * @param props 标记点属性(position, title, description)
     */
    func addMarker(id: String, props: [String: Any]) {
        guard let mapView = mapView,
              let position = props["position"] as? [String: Double],
              let latitude = position["latitude"],
              let longitude = position["longitude"] else { return }
        
        let annotation = MAPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = props["title"] as? String
        annotation.subtitle = props["snippet"] as? String ?? props["description"] as? String
        
        // 先保存 props 和 annotation，再添加到地图
        // 这样 viewFor annotation 回调时就能找到 props
        annotations[id] = annotation
        markerProps[id] = props
        
        mapView.addAnnotation(annotation)
    }
    
    /**
     * 根据 annotation 获取 marker 属性
     * @param annotation 标记点对象
     * @return 对应的属性字典
     */
    func getMarkerProps(for annotation: MAAnnotation) -> [String: Any]? {
        guard let id = getMarkerId(for: annotation) else { return nil }
        return markerProps[id]
    }
    
    /**
     * 移除标记点
     * @param id 标记点唯一标识
     */
    func removeMarker(id: String) {
        guard let mapView = mapView, let annotation = annotations[id] else { return }
        mapView.removeAnnotation(annotation)
        annotations.removeValue(forKey: id)
        markerProps.removeValue(forKey: id)
    }
    
    /**
     * 更新标记点
     * @param id 标记点唯一标识
     * @param props 新的标记点属性
     */
    func updateMarker(id: String, props: [String: Any]) {
        removeMarker(id: id)
        addMarker(id: id, props: props)
    }
    
    /**
     * 根据 annotation 获取 markerId
     * @param annotation 标记点对象
     * @return 对应的 markerId，如果未找到返回 nil
     */
    func getMarkerId(for annotation: MAAnnotation) -> String? {
        return annotations.first(where: { $0.value === annotation })?.key
    }
    
    // MARK: - Polyline 折线
    
    /**
     * 添加折线覆盖物
     * @param id 折线唯一标识
     * @param props 折线属性(points, strokeWidth, strokeColor, texture)
     */
    func addPolyline(id: String, props: [String: Any]) {
        guard let mapView = mapView,
              let points = props["points"] as? [[String: Double]] else {
            return
        }
        
        var coordinates: [CLLocationCoordinate2D] = []
        for point in points {
            guard let lat = point["latitude"], let lng = point["longitude"] else { continue }
            coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
        }
        guard coordinates.count >= 2 else {
            return
        }
        
        let polyline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))!
        
        // 先保存样式和 overlay，再添加到地图
        overlayStyles[id] = props
        overlays[id] = polyline
        mapView.add(polyline)
    }
    
    /**
     * 移除折线覆盖物
     * @param id 折线唯一标识
     */
    func removePolyline(id: String) {
        guard let mapView = mapView, let polyline = overlays[id] else { return }
        mapView.remove(polyline)
        overlays.removeValue(forKey: id)
        overlayStyles.removeValue(forKey: id)
    }
    
    /**
     * 更新折线覆盖物
     * @param id 折线唯一标识
     * @param props 新的折线属性
     */
    func updatePolyline(id: String, props: [String: Any]) {
        removePolyline(id: id)
        addPolyline(id: id, props: props)
    }
    
    // MARK: - Polygon 多边形
    
    /**
     * 添加多边形覆盖物
     * @param id 多边形唯一标识
     * @param props 多边形属性(points, fillColor, strokeColor, strokeWidth)
     */
    func addPolygon(id: String, props: [String: Any]) {
        guard let mapView = mapView,
              let points = props["points"] as? [[String: Double]] else { return }
        var coordinates: [CLLocationCoordinate2D] = []
        for point in points {
            guard let lat = point["latitude"], let lng = point["longitude"] else { continue }
            coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
        }
        guard !coordinates.isEmpty else { return }
        let polygon = MAPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
        overlayStyles[id] = props
        overlays[id] = polygon
        mapView.add(polygon!)
    }
    
    /**
     * 移除多边形覆盖物
     * @param id 多边形唯一标识
     */
    func removePolygon(id: String) {
        guard let mapView = mapView, let polygon = overlays[id] else { return }
        mapView.remove(polygon)
        overlays.removeValue(forKey: id)
        overlayStyles.removeValue(forKey: id)
    }
    
    /**
     * 更新多边形覆盖物
     * @param id 多边形唯一标识
     * @param props 新的多边形属性
     */
    func updatePolygon(id: String, props: [String: Any]) {
        removePolygon(id: id)
        addPolygon(id: id, props: props)
    }
    
    // MARK: - Renderer 渲染器
    
    /**
     * 获取覆盖物渲染器
     * @param overlay 覆盖物对象
     * @return 对应的渲染器
     */
    func getRenderer(for overlay: MAOverlay) -> MAOverlayRenderer? {
        let id = overlays.first(where: { $0.value === overlay })?.key
        let style = id != nil ? overlayStyles[id!] : nil
        
        if let circle = overlay as? MACircle {
            guard let renderer = MACircleRenderer(circle: circle) else {
                return nil
            }
            
            if let fillColor = style?["fillColor"] {
                renderer.fillColor = ColorParser.parseColor(fillColor)
            }
            if let strokeColor = style?["strokeColor"] {
                renderer.strokeColor = ColorParser.parseColor(strokeColor)
            }
            if let strokeWidth = style?["strokeWidth"] as? Double {
                renderer.lineWidth = CGFloat(strokeWidth)
            }
            
            return renderer
        } else if let polyline = overlay as? MAPolyline {
            let renderer = MAPolylineRenderer(polyline: polyline)!
            
            print("🔷 OverlayManager.getRenderer(Polyline): style=\(String(describing: style))")
            
            // 设置线宽
            if let width = style?["width"] as? Double {
                renderer.lineWidth = CGFloat(width)
                print("🔷 OverlayManager: width=\(width)")
            } else if let strokeWidth = style?["strokeWidth"] as? Double {
                renderer.lineWidth = CGFloat(strokeWidth)
                print("🔷 OverlayManager: strokeWidth=\(strokeWidth)")
            } else {
                renderer.lineWidth = 8
                print("🔷 OverlayManager: 使用默认 width=8")
            }
            
            // 设置线条样式
            renderer.lineJoinType = kMALineJoinRound
            renderer.lineCapType = kMALineCapRound
            
            // 设置纹理或颜色
            if let textureUrl = style?["texture"] as? String, !textureUrl.isEmpty {
                print("🔷 OverlayManager: 加载纹理 \(textureUrl)")
                loadPolylineTexture(url: textureUrl, renderer: renderer)
            } else {
                if let color = style?["color"] {
                    let parsedColor = ColorParser.parseColor(color)
                    renderer.strokeColor = parsedColor ?? .red
                    print("🔷 OverlayManager: color=\(color) -> \(String(describing: parsedColor))")
                } else if let strokeColor = style?["strokeColor"] {
                    let parsedColor = ColorParser.parseColor(strokeColor)
                    renderer.strokeColor = parsedColor ?? .red
                    print("🔷 OverlayManager: strokeColor=\(strokeColor) -> \(String(describing: parsedColor))")
                } else {
                    renderer.strokeColor = .red
                    print("🔷 OverlayManager: 使用默认红色")
                }
            }
            
            return renderer
        } else if let polygon = overlay as? MAPolygon {
            guard let renderer = MAPolygonRenderer(polygon: polygon) else {
                return nil
            }
            
            print("🔶 OverlayManager.getRenderer(Polygon): style=\(String(describing: style))")
            
            // 设置填充颜色
            if let fillColor = style?["fillColor"] {
                let parsedColor = ColorParser.parseColor(fillColor)
                renderer.fillColor = parsedColor
                print("🔶 OverlayManager: fillColor=\(fillColor) -> \(String(describing: parsedColor))")
            }
            // 设置边框颜色
            if let strokeColor = style?["strokeColor"] {
                let parsedColor = ColorParser.parseColor(strokeColor)
                renderer.strokeColor = parsedColor
                print("🔶 OverlayManager: strokeColor=\(strokeColor) -> \(String(describing: parsedColor))")
            }
            // 设置边框宽度
            if let strokeWidth = style?["strokeWidth"] as? Double {
                renderer.lineWidth = CGFloat(strokeWidth)
                print("🔶 OverlayManager: strokeWidth=\(strokeWidth)")
            }
            
            return renderer
        }
        
        return nil
    }
    
    /**
     * 加载折线纹理图片
     * @param url 图片 URL (支持 http/https/file/本地资源)
     * @param renderer 折线渲染器
     */
    private func loadPolylineTexture(url: String, renderer: MAPolylineRenderer) {
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            // 网络图片
            guard let imageUrl = URL(string: url) else {
                return
            }
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
                if let error = error {
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self?.applyPolylineTexture(image: image, to: renderer)
                }
            }.resume()
        } else if url.hasPrefix("file://") {
            // 本地文件
            let path = String(url.dropFirst(7))
            if let image = UIImage(contentsOfFile: path) {
                applyPolylineTexture(image: image, to: renderer)
            }
        } else {
            // 资源文件
            if let image = UIImage(named: url) {
                applyPolylineTexture(image: image, to: renderer)
            }
        }
    }
    
    /**
     * 应用纹理到折线渲染器
     * @param image 纹理图片
     * @param renderer 折线渲染器
     */
    private func applyPolylineTexture(image: UIImage, to renderer: MAPolylineRenderer) {
        renderer.strokeImage = image
    }
    
    /**
     * 清除所有覆盖物和标记点
     */
    func clear() {
        guard let mapView = mapView else { return }
        for overlay in overlays.values {
            mapView.remove(overlay)
        }
        for annotation in annotations.values {
            mapView.removeAnnotation(annotation)
        }
        overlays.removeAll()
        overlayStyles.removeAll()
        annotations.removeAll()
    }
}
