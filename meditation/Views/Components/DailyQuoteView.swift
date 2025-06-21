import SwiftUI

struct DailyQuoteView: View {
    private let quote: Quote = Quote.sampleQuotes.randomElement() ?? Quote(text: "오늘도 고요함을 느껴보세요.")

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("오늘의 한마디")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\u201C\(quote.text)\u201D")
                .font(.headline)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct DailyQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        DailyQuoteView()
    }
}
