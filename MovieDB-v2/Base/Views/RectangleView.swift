
import SwiftUI

struct RectangleView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray)
//            .opacity(0.5)
    }
}

struct RectangleView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleView()
    }
}
