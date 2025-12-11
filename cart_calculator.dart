///과제1///
void main()
 {grade();  shopping();}

void grade() 
{
int score = 84;
String grade = '';
if (score >= 90 && score <= 100) 
{grade = 'A등급'; } 
else if (score >= 80 && score <= 89) {grade = 'B등급';} 
else {grade = 'C등급';}

  print('이 학생의 점수는 $score 이며, 등급은 $grade 입니다!');
}
///과제2///
void shopping() {
  // 1. 장바구니 목록
  List<String> cart = ["티셔츠", "바지", "모자", "티셔츠", "바지"];

  // 2. 금액 관련 변수들
  int total = 0;        // 전체 상품 가격 합계
  int discount = 0;     // 할인 금액
  int finalPrice = 0;   // 최종 결제 금액

  // 3. 장바구니 전체 금액 계산
  for (String item in cart) {
    if (item == "티셔츠") {
      total += 10000;
    } else if (item == "바지") {
      total += 8000;
    } else if (item == "모자") {
      total += 4000;
    }
  }

  print("장바구니에 ${total}원 어치를 담으셨네요 !");

  // 4. 총 금액이 20,000원 이상이면 10% 할인
  if (total >= 20000) {
    discount = (total * 0.1).toInt();   // 10% 계산 → 정수로 변환
    print("할인 금액 : ${discount}원");
  }

  // 5. 최종 결제 금액 = 총액 - 할인금액
  finalPrice = total - discount;

  print("최종 결제 금액은 ${finalPrice}원입니다!");
}

///조건문과 함수 구조를 이해하는 게 어려웠고 
///중괄호 위치와 세미콜론 붙이는 규칙이 익숙하지 않아 에러가 잦았습니다
///메인 함수 안에 여러 기능을 넣는 법을 몰라서 오류가 나 수정 했습니다 