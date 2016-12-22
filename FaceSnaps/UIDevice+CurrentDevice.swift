// Usage example:
//
//    if UIDevice().type == .simulator {
//       print("You're running on the simulator... boring!")
//    } else {
//       print("Wow! Running on a \(UIDevice().type.rawValue)")
//    }

import UIKit

public enum Model : String {
    case simulator = "simulator/sandbox",
    iPod1          = "iPod 1",
    iPod2          = "iPod 2",
    iPod3          = "iPod 3",
    iPod4          = "iPod 4",
    iPod5          = "iPod 5",
    iPad2          = "iPad 2",
    iPad3          = "iPad 3",
    iPad4          = "iPad 4",
    iPhone4        = "iPhone 4",
    iPhone4S       = "iPhone 4S",
    iPhone5        = "iPhone 5",
    iPhone5S       = "iPhone 5S",
    iPhone5C       = "iPhone 5C",
    iPadMini1      = "iPad Mini 1",
    iPadMini2      = "iPad Mini 2",
    iPadMini3      = "iPad Mini 3",
    iPadAir1       = "iPad Air 1",
    iPadAir2       = "iPad Air 2",
    iPhone6        = "iPhone 6",
    iPhone6plus    = "iPhone 6 Plus",
    iPhone6S       = "iPhone 6S",
    iPhone6Splus   = "iPhone 6S Plus",
    iPhone7        = "iPhone 7",
    iPhone7Plus    = "iPhone 7 Plus",
    iPhoneSE       = "iPhone SE",
    unrecognized   = "?unrecognized?"
}

public enum DeviceType {
    case iPhone35in
    case iPhone40in
    case iPhone47in
    case iPhone55in
    case none
}

extension UIDevice {
    var modelName: Model {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let DEVICE_IS_SIMULATOR = true
        #else
            let DEVICE_IS_SIMULATOR = false
        #endif
        
        var machineString : String = ""
        
        if DEVICE_IS_SIMULATOR == true
        {
            
            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                machineString = dir
            }
        }
        else {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            machineString = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        }
        switch machineString {
            case "iPod1,1":
                return .iPod1
            case "iPod2,1":
                return .iPod2
            case "iPod3,1":
                return .iPod3
            case "iPod4,1":
                return .iPod4
            case "iPod5,1":
                return.iPod5
            case "iPad2,1"   :
                return .iPad2
            case "iPad2,2"   :
                return .iPad2
            case "iPad2,3"   :
                return .iPad2
            case "iPad2,4"   :
                return .iPad2
            case "iPad2,5"   :
                return .iPadMini1
            case "iPad2,6"   :
                return .iPadMini1
            case "iPad2,7"   :
                return .iPadMini1
            case "iPhone3,1" :
                return .iPhone4
            case "iPhone3,2" :
                return .iPhone4
            case "iPhone3,3" :
                return .iPhone4
            case "iPhone4,1" :
                return .iPhone4S
            case "iPhone5,1" :
                return .iPhone5
            case "iPhone5,2" :
                return .iPhone5
            case "iPhone5,3" :
                return .iPhone5C
            case "iPhone5,4" :
                return .iPhone5C
            case "iPad3,1"   :
                return .iPad3
            case "iPad3,2"   :
                return .iPad3
            case "iPad3,3"   :
                return .iPad3
            case "iPad3,4"   :
                return .iPad4
            case "iPad3,5"   :
                return .iPad4
            case "iPad3,6"   :
                return .iPad4
            case "iPhone6,1" :
                return .iPhone5S
            case "iPhone6,2" :
                return .iPhone5S
            case "iPad4,1"   :
                return .iPadAir1
            case "iPad4,2"   :
                return .iPadAir2
            case "iPad4,4"   :
                return .iPadMini2
            case "iPad4,5"   :
                return .iPadMini2
            case "iPad4,6"   :
                return .iPadMini2
            case "iPad4,7"   :
                return .iPadMini3
            case "iPad4,8"   :
                return .iPadMini3
            case "iPad4,9"   :
                return .iPadMini3
            case "iPhone7,1" :
                return .iPhone6plus
            case "iPhone7,2" :
                return .iPhone6
            case "iPhone8,1" :
                return .iPhone6S
            case "iPhone8,2" :
                return .iPhone6Splus
            case "iPhone9,1", "iPhone9,3":
                return .iPhone7
            case "iPhone9,2", "iPhone9,4":
                return .iPhone7Plus
            case "iPhone8,4":
                return .iPhoneSE
            default:
                return .unrecognized
        }
    }
    
    var deviceType: DeviceType {
        switch self.modelName {
        case .iPhone4S:
            return .iPhone35in
        case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE:
            return .iPhone40in
        case .iPhone6, .iPhone6S, .iPhone7:
            return .iPhone47in
        case .iPhone6plus, .iPhone6Splus, .iPhone7Plus:
            return .iPhone55in
        default:
            return .none
        }
    }
}
