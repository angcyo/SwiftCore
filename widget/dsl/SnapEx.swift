//
// Created by wayto on 2021/7/29.
//

import Foundation
import SnapKit

enum ConstraintTarget: ConstraintRelatableTarget {
    //父控件
    case PARENT
    //父控件中的最后一个控件, 排除自己
    case LAST
}