import 'dart:io';

/// 점수만 나타내는 부모 클래스 Score
class Score {
  int score; // 점수 값(정수)

  // 생성자: Score(this.score);
  // → Score 객체를 만들 때 점수 값을 받아서 필드에 넣어줌
  Score(this.score);

  /// 점수만 출력하는 메서드
  void showInfo() {
    print('점수: $score');
  }
}

/// 학생 이름 + 점수를 나타내는 자식 클래스 StudentScore
class StudentScore extends Score {
  String name; // 학생 이름

  // 생성자
  // required this.name  → name은 꼭 받아야 함
  // required int score → 점수도 꼭 받아야 함
  // : super(score)     → 부모 클래스(Score)의 생성자에 score 전달
  StudentScore({
    required this.name,
    required int score,
  }) : super(score);

  /// 부모의 showInfo()를 학생 정보용으로 재정의(override)
  @override
  void showInfo() {
    print('이름: $name, 점수: $score');
  }
}

/// students.txt 파일을 읽어서 List<StudentScore> 로 반환하는 함수
List<StudentScore> loadStudentData(String filePath) {
  // 학생 정보를 담을 리스트
  List<StudentScore> students = [];

  try {
    // filePath 경로의 파일 객체 생성
    final file = File(filePath);

    // 파일의 모든 줄을 한 번에 읽어옴 (동기 방식)
    final lines = file.readAsLinesSync();

    // 각 줄을 하나씩 처리
    for (var line in lines) {
      // "홍길동,90" → ["홍길동", "90"]
      final parts = line.split(',');

      // 이름,점수 두 개가 아니면 형식 오류
      if (parts.length != 2) {
        throw FormatException('잘못된 데이터 형식: $line');
      }

      // 앞부분은 이름, 뒷부분은 점수 문자열
      final String name = parts[0].trim();        // 공백 제거
      final int score = int.parse(parts[1].trim()); // "90" → 90

      // StudentScore 객체 만들어서 리스트에 추가
      students.add(StudentScore(name: name, score: score));
    }
  } catch (e) {
    // 파일 읽기나 파싱 중에 오류가 나면 여기로 들어옴
    print("학생 데이터를 불러오는 데 실패했습니다: $e");
    exit(1); // 프로그램 종료
  }

  return students;
}

/// 리스트에서 특정 학생 찾기
/// students 리스트 중에서 name이 같은 학생을 찾아 반환.
/// 못 찾으면 null.
StudentScore? findStudentByName(List<StudentScore> students, String name) {
  for (var student in students) {
    if (student.name == name) {
      return student;
    }
  }
  return null; // 못 찾은 경우
}

/// 결과를 result.txt에 저장하는 함수
/// filePath : 저장할 파일 이름/경로
/// content  : 파일 안에 쓸 문자열 내용
void saveResult(String filePath, String content) {
  try {
    final file = File(filePath);          // 파일 객체 생성
    file.writeAsStringSync(content);      // 문자열을 파일에 기록
    print("저장이 완료되었습니다.");       // 성공 메시지
  } catch (e) {
    // 파일 쓰기 중 에러 발생
    print("저장에 실패했습니다: $e");
  }
}

/// 메인 실행 흐름
void main() {
  // 1. students.txt 파일을 읽어서 학생 리스트(List<StudentScore>)를 가져옴
  //    → 파일에 "홍길동,90" 이런 식으로 저장되어 있어야 함.
  List<StudentScore> students = loadStudentData("students.txt");

  // 2. 사용자가 올바른 학생 이름을 입력할 때까지 저장해둘 변수
  //    → 처음에는 null, 올바른 이름이 들어오면 실제 StudentScore가 들어감.
  StudentScore? selectedStudent;

  // 3.  *** while 반복문: 올바른 학생 이름이 나올 때까지 계속 묻는 부분
  while (selectedStudent == null) {
    stdout.write("어떤 학생의 통계를 확인하시겠습니까? ");

    // 사용자 입력 받기 (문자열, null 가능)
    String? input = stdin.readLineSync();

    // 3-1. 입력이 null이거나 공백이면 다시 입력 시키기
    if (input == null || input.trim().isEmpty) {
      print("이름을 입력해주세요.");
      continue;  // while의 처음으로 돌아감
    }

    // 3-2. 입력받은 이름으로 학생을 리스트에서 찾기
    selectedStudent = findStudentByName(students, input.trim());

    // 3-3. 못 찾았다면 메시지 출력 후 다시 while문 반복
    if (selectedStudent == null) {
      print("잘못된 학생 이름을 입력하셨습니다. 다시 입력해주세요.");
    }
  }

  // ========= 여기부터는 selectedStudent가 null이 아닐 때만 실행됨 ========= //

  // 4. 찾은 학생의 정보 출력
  //    예: "이름: 홍길동, 점수: 90"
  selectedStudent.showInfo();

  // 5. 파일에 저장할 문자열 만들기
  //    → 이 문자열 그대로 result.txt에 들어감
  String resultText =
      "이름: ${selectedStudent.name}, 점수: ${selectedStudent.score}";

  // 6. 결과를 result.txt 파일로 저장
  //    → saveResult는 (파일경로, 문자열내용) 을 받도록 위에서 정의함
  saveResult("result.txt", resultText);

  // 7. 저장 완료 메세지는 saveResult() 안에서 출력됨
}
