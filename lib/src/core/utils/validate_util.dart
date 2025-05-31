class ValidateUtil {
  // 특수문자가 포함되어 있는지 확인
  static bool isContainSpecialCharacter(String value) {
    final RegExp specialCharacterRegExp = RegExp(
      r'[~!@#$%^&*,.?":;{}|\<>₩“”‘’]',
    );
    return specialCharacterRegExp.hasMatch(value);
  }

  // 한 글자라도 한글 자음/모음인 경우
  static bool containsKoreanConsonantVowel(String value) {
    // 한글 자음/모음 범위 (ㄱ-ㅎ, ㅏ-ㅣ)
    final RegExp koreanConsonantVowelRegExp = RegExp(r'[\u3131-\u3163]');

    // 문자열이 비어있지 않고, 한 글자라도 한글 자음/모음인 경우
    return value.isNotEmpty && koreanConsonantVowelRegExp.hasMatch(value);
  }

  // 한글이 최소 1자라도 있는지 확인
  static bool containsKoreanCharacter(String value) {
    // 한글 완성형(가-힣) 확인
    final RegExp koreanRegExp = RegExp(r'[가-힣]');
    return koreanRegExp.hasMatch(value);
  }

  // 숫자만 입력되었는지 확인`
  static bool isNumbersOnly(String value) {
    final RegExp numbersOnlyRegExp = RegExp(r'^[0-9]+$');
    return numbersOnlyRegExp.hasMatch(value);
  }

  // 이메일 유효성 검사 (가장 보편적인 형식)
  static bool isValidEmail(String value) {
    final RegExp emailRegExp = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );
    return emailRegExp.hasMatch(value);
  }
}
