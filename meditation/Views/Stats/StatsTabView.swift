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
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [Color("SoftBlue"), Color("DeepIndigo")],
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
                            ForEach(viewModel.moodCount.sorted(by: { $0.key < $1.key }), id: \.key) { mood, count in
                                BarMark(
                                    x: .value("감정", mood),
                                    y: .value("횟수", count)
                                )
                                .foregroundStyle(by: .value("감정", mood))
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

                    let progressData = Calendar.current.weekdaySymbols.map { day in
                        (day: day, value: viewModel.weeklyStats[day] == true ? 1 : 0)
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
