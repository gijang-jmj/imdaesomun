// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Notice {

 String get id; String get seq; int get no; String get title; String get department; int get regDate; int get hits; int get createdAt; List<Map<String, String>> get files; String get html;
/// Create a copy of Notice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeCopyWith<Notice> get copyWith => _$NoticeCopyWithImpl<Notice>(this as Notice, _$identity);

  /// Serializes this Notice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Notice&&(identical(other.id, id) || other.id == id)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.no, no) || other.no == no)&&(identical(other.title, title) || other.title == title)&&(identical(other.department, department) || other.department == department)&&(identical(other.regDate, regDate) || other.regDate == regDate)&&(identical(other.hits, hits) || other.hits == hits)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.html, html) || other.html == html));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seq,no,title,department,regDate,hits,createdAt,const DeepCollectionEquality().hash(files),html);

@override
String toString() {
  return 'Notice(id: $id, seq: $seq, no: $no, title: $title, department: $department, regDate: $regDate, hits: $hits, createdAt: $createdAt, files: $files, html: $html)';
}


}

/// @nodoc
abstract mixin class $NoticeCopyWith<$Res>  {
  factory $NoticeCopyWith(Notice value, $Res Function(Notice) _then) = _$NoticeCopyWithImpl;
@useResult
$Res call({
 String id, String seq, int no, String title, String department, int regDate, int hits, int createdAt, List<Map<String, String>> files, String html
});




}
/// @nodoc
class _$NoticeCopyWithImpl<$Res>
    implements $NoticeCopyWith<$Res> {
  _$NoticeCopyWithImpl(this._self, this._then);

  final Notice _self;
  final $Res Function(Notice) _then;

/// Create a copy of Notice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seq = null,Object? no = null,Object? title = null,Object? department = null,Object? regDate = null,Object? hits = null,Object? createdAt = null,Object? files = null,Object? html = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as String,no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,regDate: null == regDate ? _self.regDate : regDate // ignore: cast_nullable_to_non_nullable
as int,hits: null == hits ? _self.hits : hits // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<Map<String, String>>,html: null == html ? _self.html : html // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Notice implements Notice {
  const _Notice({required this.id, required this.seq, required this.no, required this.title, required this.department, required this.regDate, required this.hits, required this.createdAt, required final  List<Map<String, String>> files, required this.html}): _files = files;
  factory _Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);

@override final  String id;
@override final  String seq;
@override final  int no;
@override final  String title;
@override final  String department;
@override final  int regDate;
@override final  int hits;
@override final  int createdAt;
 final  List<Map<String, String>> _files;
@override List<Map<String, String>> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override final  String html;

/// Create a copy of Notice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeCopyWith<_Notice> get copyWith => __$NoticeCopyWithImpl<_Notice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Notice&&(identical(other.id, id) || other.id == id)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.no, no) || other.no == no)&&(identical(other.title, title) || other.title == title)&&(identical(other.department, department) || other.department == department)&&(identical(other.regDate, regDate) || other.regDate == regDate)&&(identical(other.hits, hits) || other.hits == hits)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.html, html) || other.html == html));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seq,no,title,department,regDate,hits,createdAt,const DeepCollectionEquality().hash(_files),html);

@override
String toString() {
  return 'Notice(id: $id, seq: $seq, no: $no, title: $title, department: $department, regDate: $regDate, hits: $hits, createdAt: $createdAt, files: $files, html: $html)';
}


}

/// @nodoc
abstract mixin class _$NoticeCopyWith<$Res> implements $NoticeCopyWith<$Res> {
  factory _$NoticeCopyWith(_Notice value, $Res Function(_Notice) _then) = __$NoticeCopyWithImpl;
@override @useResult
$Res call({
 String id, String seq, int no, String title, String department, int regDate, int hits, int createdAt, List<Map<String, String>> files, String html
});




}
/// @nodoc
class __$NoticeCopyWithImpl<$Res>
    implements _$NoticeCopyWith<$Res> {
  __$NoticeCopyWithImpl(this._self, this._then);

  final _Notice _self;
  final $Res Function(_Notice) _then;

/// Create a copy of Notice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seq = null,Object? no = null,Object? title = null,Object? department = null,Object? regDate = null,Object? hits = null,Object? createdAt = null,Object? files = null,Object? html = null,}) {
  return _then(_Notice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as String,no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,regDate: null == regDate ? _self.regDate : regDate // ignore: cast_nullable_to_non_nullable
as int,hits: null == hits ? _self.hits : hits // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<Map<String, String>>,html: null == html ? _self.html : html // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
