class RouterPathConstant {
  final String path;

  const RouterPathConstant._(this.path);

  String get subPath {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    return segments.isEmpty ? '' : segments.last;
  }

  /// page : home
  ///
  /// path : /
  ///
  /// description : 임대공고 리스트 페이지
  static const home = RouterPathConstant._('/');

  /// page : notice
  ///
  /// path : /notice
  ///
  /// description : 임대공고 상세 페이지
  ///
  /// parameter(*required) : id
  static const notice = RouterPathConstant._('/notice');

  /// page : community
  ///
  /// path : /community
  ///
  /// description : 커뮤니티 페이지
  static const community = RouterPathConstant._('/community');

  /// page : saved
  ///
  /// path : /saved
  ///
  /// description : 저장된 공고 페이지
  static const saved = RouterPathConstant._('/saved');

  /// page : post
  ///
  /// path : /post
  ///
  /// description : 커뮤니티 게시글 상세 페이지
  static const post = RouterPathConstant._('/post');

  /// page : profile
  ///
  /// path : /profile
  ///
  /// description : 내정보 페이지
  static const profile = RouterPathConstant._('/profile');

  /// page : log
  ///
  /// path : /log
  ///
  /// description : 로그 페이지
  static const log = RouterPathConstant._('/log');

  /// page : documentViewer
  ///
  /// path : /documentViewer
  ///
  /// description : 문서 뷰어 페이지
  static const documentViewer = RouterPathConstant._('/documentViewer');

  /// page : dialog
  ///
  /// path : /dialog
  ///
  /// description : 커스텀 다이얼로그 페이지
  ///
  /// extra(*required) : Widget dialog
  static const dialog = RouterPathConstant._('/dialog');
}
