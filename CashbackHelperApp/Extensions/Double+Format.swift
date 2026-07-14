import Foundation

extension Double {


    var percentString: String {


        if truncatingRemainder(
            dividingBy: 1
        ) == 0 {


            return "\(Int(self))%"

        }


        return "\(self)%"

    }

}