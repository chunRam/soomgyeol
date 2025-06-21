# 🌿 숨결 (Soomgyeol)  
**당신의 감정에 맞춘, 개인화된 명상 앱**

![hero](https://user-images.githubusercontent.com/yourusername/banner-image.png)

> “감정은 숨처럼 흐르고, 숨결은 당신을 돌아보게 합니다.”

---

## ✨ 소개 (Overview)

**숨결**은 감정 기반 명상 추천, 감정 일지 기록, 통계 시각화를 통해  
사용자의 정서적 균형과 자기 인식을 돕는 **개인 맞춤형 명상 앱**입니다.  
SwiftUI의 최신 UI/UX 기술과 Firebase 백엔드를 활용해,  
감성적이면서도 기능적으로 완성도 높은 구조를 지향했습니다.

---

## 📲 주요 기능 (Features)

| 기능 | 설명 |
|------|------|
| 🎭 감정 선택 | 오늘의 기분을 감정 카드로 직관적으로 선택 |
| 🎧 명상 시작 | 명상 시간 및 배경 음악(비/싱잉볼/새소리) 설정 후 명상 시작 |
| 📝 감정 일지 | 명상 후 일기 작성 및 Firebase에 저장 |
| 🔍 필터 & 검색 | 감정/내용 기반 검색 및 필터링 기능 |
| 📊 통계 시각화 | 감정 분포, 누적 시간, 주간 달성률 등 시각적 통계 제공 |
| 👤 사용자 인증 | Firebase 이메일 인증 / 자동 로그인 / 로그아웃 |

---

## 🖥️ 데모 이미지 (Screenshots)

| 홈 화면 | 감정 선택 | 명상 진행 | 통계 화면 |
|---------|------------|-----------|------------|
| ![](https://user-images.githubusercontent.com/yourusername/home.png) | ![](https://user-images.githubusercontent.com/yourusername/mood.png) | ![](https://user-images.githubusercontent.com/yourusername/meditation.png) | ![](https://user-images.githubusercontent.com/yourusername/stats.png) |

> 📸 추가 GIF: 사용 흐름 전체 [🔗Watch Demo](https://your-demo-link.com)

---

## 🛠️ 기술 스택 (Tech Stack)

| 기술 | 설명 |
|------|------|
| **SwiftUI** | 최신 선언형 iOS UI 프레임워크 |
| **Firebase Auth** | 이메일 기반 사용자 인증 |
| **Firebase Firestore** | 감정 일지 및 사용자 데이터 저장 |
| **AVFoundation** | 명상 오디오 재생 |
| **Charts (iOS 16+)** | 통계 시각화를 위한 그래프 지원 |
| **MVVM 구조** | 유지보수 및 확장성 고려한 구조 설계 |

---

## 📂 프로젝트 구조 (Project Structure)

Soomgyeol/
├── App/
│ ├── AppRootView.swift
│ ├── AppState.swift
│ └── meditationApp.swift
├── Models/
│ ├── Mood.swift
│ ├── JournalEntry.swift
│ └── MeditationSession.swift
├── ViewModels/
│ ├── JournalViewModel.swift
│ ├── AuthViewModel.swift
│ └── MoodViewModel.swift
├── Views/
│ ├── LaunchView.swift
│ ├── HomeTabView.swift
│ ├── MeditationStartView.swift
│ ├── HistoryTabView.swift
│ ├── StatsTabView.swift
│ └── SettingsView.swift
├── Resources/
│ ├── Assets.xcassets/
│ ├── meditation1.mp3 // 비소리
│ ├── meditation2.mp3 // 싱잉볼
│ └── meditation3.mp3 // 새소리
└── GoogleService-Info.plist
---

## 🚀 시작하기 (Getting Started)

```bash
# 1. 저장소 클론
git clone https://github.com/chunRam/soomgyeol.git
cd soomgyeol

# 2. Xcode로 열기
open Soomgyeol.xcodeproj

# 3. Firebase 설정
# Firebase Console에서 GoogleService-Info.plist 다운로드 후, 프로젝트 루트에 추가
