import SwiftUI

struct DisclaimerView: View {
    var onAccept: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "exclamationmark.bubble.fill")
                .font(.system(size: 68))
                .foregroundStyle(.orange)

            Text("Entertainment Notice")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("“This app is for entertainment purposes only.\nDo not use this app to harass, bully, or disturb others.\nThe developer is not responsible for misuse of this application.”")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.yellow.opacity(0.2), in: RoundedRectangle(cornerRadius: 16))

            Button("I Understand") {
                onAccept()
            }
            .font(.headline)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background(Color.green, in: Capsule())
            .foregroundStyle(.white)

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(colors: [.pink.opacity(0.3), .blue.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    DisclaimerView(onAccept: {})
}
