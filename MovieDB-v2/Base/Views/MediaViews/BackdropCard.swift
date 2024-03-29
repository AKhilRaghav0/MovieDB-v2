
import SwiftUI

struct BackdropCard<T: MediaProtocol>: View {
    let content: T
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RectangleView()
                
                AsyncImage(url: content.backdropURL) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        Image(systemName: "video")
                    } else {
                        ProgressView()
                    }
                }
            }
            .overlay {
                Image(systemName: "play.circle")
                    .font(.system(size: 80))
                    .fontWeight(.light)
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
            }
            .aspectRatio(16/9, contentMode: .fit)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(content.title)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text("2023")
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct BackdropCard_Previews: PreviewProvider {
    static var previews: some View {
        BackdropCard(content: Movie.localMovie)
            .padding()
    }
}
