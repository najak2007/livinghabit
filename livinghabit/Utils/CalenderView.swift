
import SwiftUI

struct CalenderView: View {
    @State private var date = Date()
    
    var body: some View {
        DatePicker(
            "",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(.compact)
    }
}
