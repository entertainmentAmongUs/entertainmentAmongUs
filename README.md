# entertainmentAmongUs

## ▦ 개발 규칙

### Git Commit Message 규약

- Git Commit Message Template

```bash
[feat] : [contents] /FE
# [속성] : 내용 /FE 또는 /BE
##### 제목은 최대 50 글자까지만 입력
##### -> [feat] : 이메일 중복검사 /FE


######## 본문은 한 줄에 최대 72 글자까지만 입력
############################


######## 꼬리말은 Optional

#   속성 분류
#   feat       : 새로운 기능 추가
#   fix        : 버그 수정
#   design     : CSS 등 사용자 UI 디자인 변경
#   ci         : CI 관련 설정 수정에 대한 커밋
#   docs       : 문서 수정
#   build      : 빌드 관련, 패키지 매니저 수정(npm, yarn)
#   chore      : 그 외 자잘한 수정사항
#   rename     : 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우

# ------------------
#     제목 첫 글자를 대문자로 시작 
#     제목은 명령문으로 작성
#     제목 끝에 마침표(.) 금지
#     제목과 본문을 한 줄 띄워 분리하기
#     본문은 한 줄당 72자 내로 작성.
#     본문 내용은 양에 구애받지 말고 최대한 상세히 작성
#     본문은 "어떻게" 보다 "무엇을", "왜"를 설명
#     본문에 여러줄의 메시지를 작성할 땐 "-"로 구분
# ------------------

#     꼬리말은 optional이고 이슈 트래커 ID를 작성합니다.
#     꼬리말은 "[유형] [이슈 번호]" 형식으로 사용합니다.
#     여러 개의 이슈 번호를 적을 때는 쉼표로 구분합니다.
#     이슈 트래커 유형은 다음 중 하나를 사용합니다.
#        - Resolves : 이슈를 해결했을 때 사용
#       ex) Resolves S05P12A10190
#        - [이슈 번호] #comment [댓글 내용]
#        : 댓글 남기기

```

```
git config --global commit.template <.gitmessage.txt 경로>
```
<br>

### Git Flow 규약

Ref : https://techblog.woowahan.com/2553/

#### Branch

**Master - (fix) - Develop - Feature**

- Master : 제품으로 출시될 수 있는 브랜치
- Develop : 다음 출시 버전을 개발하는 브랜치
- Feature : 기능을 개발하는 브랜치
- Fix : 발생한 버그를 수정 하는 브랜치
  <br>

#### Branch Naming 규칙

```
Master, Develop = 수정X
feature/fe(be)/기능명
- feature/fe/login
- feature/be/login
```

#### feature 브랜치 생성 방법

```
//develop 브랜치에서 생성
$ git checkout -b feature/fe(be)/login develop
```

#### Merge 규칙

- merge를 하기 전 적어도 1명의 팀원에게 알리고 코드 리뷰가 가능하면 수행 후 merge
- merge 후 branch 삭제
