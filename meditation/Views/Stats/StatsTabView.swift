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

                if viewModel.hasError, let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                // 총 명상 시간
                VStack(alignment: .leading, spacing: 8) {
                    Text("누적 명상 시간")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text("\(viewModel.totalMinutes)분")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color("SoftBlue"))
                }
                .padding()
                .background(Color("SoftBlue").opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)

                // 감정별 분포 차트
                VStack(alignment: .leading, spacing: 8) {
                    Text("감정별 분포")
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

                // 주간 명상 목표 달성률
                VStack(alignment: .leading, spacing: 8) {
                    Text("주간 명상 목표")
                        .font(.headline)
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        ForEach(Calendar.current.weekdaySymbols, id: \.self) { day in
                            VStack(spacing: 4) {
                                Text(String(day.prefix(1))) // 요일 첫 글자
                                    .font(.caption2)
                                    .foregroundColor(.secondary)

                                Circle()
                                    .fill(viewModel.weeklyStats[day] == true ? Color("Lavender") : Color.gray.opacity(0.3))
                                    .frame(width: 16, height: 16)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchStats()
        }
        .background(Color.white.ignoresSafeArea())
    }
}
