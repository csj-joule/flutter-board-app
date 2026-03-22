# Flutter 게시판 앱

Flutter + Provider를 사용한 게시판(Bulletin Board) 앱입니다.

## 주요 기능

- **게시글 CRUD**: 작성, 조회, 수정, 삭제
- **댓글 기능**: 게시글에 댓글 작성 및 삭제
- **검색**: 제목, 내용, 작성자 기준 검색
- **조회수**: 게시글 조회수 카운트
- **Material Design 3**: 시스템 다크모드 자동 지원

## 기술 스택

- Flutter 3.x
- Provider (상태관리)
- Material Design 3

## 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점
├── models/
│   ├── post.dart                # 게시글 모델
│   └── comment.dart             # 댓글 모델
├── providers/
│   └── board_provider.dart      # 상태 관리 (ChangeNotifier)
└── screens/
    ├── post_list_screen.dart    # 게시글 목록 화면
    ├── post_detail_screen.dart  # 게시글 상세 + 댓글 화면
    └── post_form_screen.dart    # 게시글 작성/수정 화면
```

## 실행 방법

```bash
flutter pub get
flutter run
```
