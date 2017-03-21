//
//  FSImageFilter.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/20/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

enum FSImageFilter: Int {
    case normal = 0, clarendon, gingham, moon, lark, valencia, nashville, sepia, arden, noah
    
    var stringRepresentation: String {
        switch self {
        case .normal:
            return "Normal"
        case .clarendon:
            return "Clarendon"
        case .gingham:
            return "Gingham"
        case .moon:
            return "Moon"
        case .lark:
            return "Lark"
        case .valencia:
            return "Valencia"
        case .nashville:
            return "Nashville"
        case .sepia:
            return "Sepia"
        case .arden:
            return "Arden"
        case .noah:
            return "Noah"
        }
    }
    
    static let availableFilters: [FSImageFilter] = [.normal, .clarendon, .gingham, .moon, .lark, .valencia, .nashville, .sepia, .arden, .noah]
    
    
}
