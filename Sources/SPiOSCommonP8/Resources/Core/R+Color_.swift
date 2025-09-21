//
//  R+Color_.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 21/09/25.
//

import Foundation
import UIKit
extension R{
    public final class Color_{
        private  var bundle: Bundle
        public init(bundle: Bundle) {
            self.bundle = bundle
        }
        public func uiColor(key:String)->UIColor{
            return UIColor(named: key, in: bundle, compatibleWith: nil)!
            
        }
        public actor FW { }
        public actor App { }
    }
}

