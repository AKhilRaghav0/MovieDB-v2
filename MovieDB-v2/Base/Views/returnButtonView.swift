import SwiftUI

struct returnButtonView: View {
    var body: some View {
        Image(systemName: "chevron.left")
            .font(.title3)
            .foregroundStyle(.orange)
            .shadow(radius: 20)
    }
}

#Preview {
    returnButtonView()
}
