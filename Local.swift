import Foundation
import MapKit

open class Local : NSObject, MKAnnotation {
    open var title : String?
    open var subtitle : String? = nil
    open var coordinate : CLLocationCoordinate2D
    open var tipo = TipoLocal.trabalho
    
    public init(nome : String, coordenada : CLLocationCoordinate2D) {
        self.title = nome
        self.coordinate = coordenada
    }
    
    open func cor() -> UIColor {
        switch tipo {
        case TipoLocal.trabalho:
            return UIColor.red
        case TipoLocal.lazer:
            return UIColor.green
        case TipoLocal.residencia:
            return UIColor.blue
        default:
            return UIColor.purple
        }
    }
}
