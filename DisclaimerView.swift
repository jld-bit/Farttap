import SwiftUI

struct DisclaimerView: View {
    let onAccept: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Entertainment Notice")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("This app is for entertainment purposes only.\nDo not use this app to harass, bully, or disturb others.\nThe developer is not responsible for misuse of this application.")
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.orange.opacity(0.2), in: RoundedRectangle(cornerRadius: 16))

            Button("I Understand") {
                onAccept()
            }
            .font(.headline)
            .padding(.horizontal, 26)
            .padding(.vertical, 12)
            .background(Color.green, in: Capsule())
            .foregroundStyle(.white)

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(colors: [.yellow.opacity(0.25), .pink.opacity(0.25)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    DisclaimerView(onAccept: {})
}
