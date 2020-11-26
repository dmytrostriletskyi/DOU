import Foundation

enum DeviceType: String, CaseIterable {
    static var allIpadDevices: [DeviceType] {
        return [
            .iPad2, .iPad3, .iPad4, .iPad5, .iPad6, .iPad7, .iPad8, .iPadAir,
            .iPadAir2, .iPadAir3, .iPadAir4, .iPadMini, .iPadMini2, .iPadMini3,
            .iPadMini4, .iPadMini5, .iPadPro9_7, .iPadPro10_5, .iPadPro11_1st,
            .iPadPro11_2nd, .iPadPro12_1st, .iPadPro12_2nd, .iPadPro12_3rd,
            .iPadPro12_4th
        ]
    }

    static var allIPadDevicesList: [String] {
        return DeviceType.allIpadDevices.map { $0.rawValue }
    }

    case iPad2 = "iPad 2"
    case iPad3 = "iPad (3rd generation)"
    case iPad4 = "iPad (4th generation)"
    case iPad5 = "iPad (5th generation)"
    case iPad6 = "iPad (6th generation)"
    case iPad7 = "iPad (7th generation)"
    case iPad8 = "iPad (8th generation)"
    case iPadAir = "iPad Air"
    case iPadAir2 = "iPad Air 2"
    case iPadAir3 = "iPad Air (3rd generation)"
    case iPadAir4 = "iPad Air (4th generation)"
    case iPadMini = "iPad mini"
    case iPadMini2 = "iPad mini 2"
    case iPadMini3 = "iPad mini 3"
    case iPadMini4 = "iPad mini 4"
    case iPadMini5 = "iPad mini (5th generation)"
    case iPadPro9_7 = "iPad Pro (9.7-inch)"
    case iPadPro10_5 = "iPad Pro (10.5-inch)"
    case iPadPro11_1st = "iPad Pro (11-inch) (1st generation)"
    case iPadPro11_2nd = "iPad Pro (11-inch) (2nd generation)"
    case iPadPro12_1st = "iPad Pro (12.9-inch) (1st generation)"
    case iPadPro12_2nd = "iPad Pro (12.9-inch) (2nd generation)"
    case iPadPro12_3rd = "iPad Pro (12.9-inch) (3rd generation)"
    case iPadPro12_4th = "iPad Pro (12.9-inch) (4th generation)"
}
