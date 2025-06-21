# 🌿 숨결 Meditation 앱

SwiftUI와 Firebase로 개발된 트렌디한 명상 앱입니다. 오늘의 기분을 선택하고, 음악과 함께 마음을 가다듬어 보세요.

## 🚀 시작하기
1. 이 저장소를 클론하거나 업데이트합니다.
2. Xcode 15 이상에서 `Meditation.xcodeproj` 파일을 엽니다.
3. 필요한 Swift 패키지는 자동으로 받아옵니다.
4. **Meditation** 타겟을 빌드하고 실행합니다.

Firebase 설정 파일 `GoogleService-Info.plist`가 `meditation/` 디렉터리에 포함되어 있으니 별도 설정 없이 바로 사용할 수 있습니다.

## ✨ 주요 기능
- FirebaseAuth 기반 이메일 로그인/회원가입
- 기분별 맞춤 명상 콘텐츠 제공
- 명상 타이머와 배경 음악 재생 기능
- 저널 기록 및 통계 확인
- SwiftUI로 구현된 깔끔한 UI

## 📂 프로젝트 구조
```
Meditation.xcodeproj/   Xcode 프로젝트 파일
meditation/             앱 소스 코드와 리소스
└── Services/           Firebase, 오디오 등 서비스 로직
└── ViewModels/         화면별 상태 관리
└── Views/              SwiftUI 화면 구성
```

트렌디한 명상 경험을 원한다면 지금 바로 **숨결**을 실행해 보세요!
