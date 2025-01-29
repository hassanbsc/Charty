// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import Charts

public struct ChartView: View {
    public var body: some View {
        VStack {
            Text("Sample Chart")
            LineChartView()
                .frame(height: 300)
        }
    }
}

struct LineChartView: UIViewRepresentable {
    func makeUIView(context: Context) -> LineChartView {
        let chartView = LineChartView()
        
        let dataSet = LineChartDataSet(entries: [
            ChartDataEntry(x: 0, y: 1),
            ChartDataEntry(x: 1, y: 2),
            ChartDataEntry(x: 2, y: 3),
            ChartDataEntry(x: 3, y: 4)
        ])
        
        chartView.data = LineChartData(dataSet: dataSet)
        return chartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {}
}
