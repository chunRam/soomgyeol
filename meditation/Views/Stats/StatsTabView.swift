import SwiftUI
import Charts

struct StatsTabView: View {
    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                Text("📊 통계")
                    .font(.largeTitle.bold())
                    .padding(.top)
                    .padding(.horizontal)

                Picker("기간", selection: $viewModel.timeRange) {
                    ForEach(StatsViewModel.TimeRange.allCases) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if viewModel.hasError, let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                // 총 명상 시간
                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Text("누적 명상 시간")
                    } icon: {
                        Image(systemName: "clock.fill")
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)

                    Text("\(viewModel.totalMinutes)분")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("세션 수")
                                .font(.caption)
                            Text("\(viewModel.sessionCount)")
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("평균 시간")
                                .font(.caption)
                            Text("\(Int(viewModel.averageSessionMinutes))분")
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("최장 세션")
                                .font(.caption)
                            Text("\(viewModel.longestSessionMinutes)분")
                                .font(.headline)
                        }
                    }
                    .padding(.top, 4)
                    .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [Color("PastelPink"), Color("PastelPurple")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal)

                // 감정별 분포 차트
                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Text("감정별 분포")
                    } icon: {
                        Image(systemName: "chart.bar.fill")
                    }
                    .font(.headline)
                    .padding(.horizontal)

                    if viewModel.moodCount.isEmpty {
                        Text("아직 기록된 감정이 없습니다.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        Chart {
                            ForEach(viewModel.moodCount.sorted(by: { $0.key < $1.key }), id: \.key) { moodId, count in
                                let moodName = Mood.mood(for: moodId)?.name ?? moodId
                                BarMark(
                                    x: .value("감정", moodName),
                                    y: .value("횟수", count)
                                )
                                .foregroundStyle(by: .value("감정", moodName))
                            }
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal)

                // 주간 명상 목표 달성률
                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Text("주간 명상 목표")
                    } icon: {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                    }
                    .font(.headline)
                    .padding(.horizontal)

                    Stepper("목표: \(viewModel.weeklyGoal)일", value: $viewModel.weeklyGoal, in: 1...7)
                        .padding(.horizontal)

                    ProgressView(value: viewModel.weeklyProgress)
                        .padding(.horizontal)

                    let calendar = Calendar.current
                    let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
                    let progressData = (0..<7).compactMap { offset -> (day: String, value: Int)? in
                        guard let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) else { return nil }
                        let weekday = calendar.component(.weekday, from: date)
                        let symbol = calendar.weekdaySymbols[weekday - 1]
                        return (day: symbol, value: viewModel.weeklyStats[symbol] == true ? 1 : 0)
                    }

                    Chart {
                        ForEach(progressData, id: \.day) { item in
                            LineMark(
                                x: .value("Day", item.day),
                                y: .value("완료", item.value)
                            )
                            PointMark(
                                x: .value("Day", item.day),
                                y: .value("완료", item.value)
                            )
                        }
                    }
                    .frame(height: 160)
                    .padding(.horizontal)
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal)

                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchStats()
        }
        .background(Color.white.ignoresSafeArea())
    }
}
