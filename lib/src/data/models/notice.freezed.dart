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

 String get id; String get seq; String get title; String get regDate; int get hits; String get department; String get corporation; String get createAt; String? get content; String? get summary;
/// Create a copy of Notice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeCopyWith<Notice> get copyWith => _$NoticeCopyWithImpl<Notice>(this as Notice, _$identity);

  /// Serializes this Notice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Notice&&(identical(other.id, id) || other.id == id)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.title, title) || other.title == title)&&(identical(other.regDate, regDate) || other.regDate == regDate)&&(identical(other.hits, hits) || other.hits == hits)&&(identical(other.department, department) || other.department == department)&&(identical(other.corporation, corporation) || other.corporation == corporation)&&(identical(other.createAt, createAt) || other.createAt == createAt)&&(identical(other.content, content) || other.content == content)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seq,title,regDate,hits,department,corporation,createAt,content,summary);

@override
String toString() {
  return 'Notice(id: $id, seq: $seq, title: $title, regDate: $regDate, hits: $hits, department: $department, corporation: $corporation, createAt: $createAt, content: $content, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $NoticeCopyWith<$Res>  {
  factory $NoticeCopyWith(Notice value, $Res Function(Notice) _then) = _$NoticeCopyWithImpl;
@useResult
$Res call({
 String id, String seq, String title, String regDate, int hits, String department, String corporation, String createAt, String? content, String? summary
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seq = null,Object? title = null,Object? regDate = null,Object? hits = null,Object? department = null,Object? corporation = null,Object? createAt = null,Object? content = freezed,Object? summary = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,regDate: null == regDate ? _self.regDate : regDate // ignore: cast_nullable_to_non_nullable
as String,hits: null == hits ? _self.hits : hits // ignore: cast_nullable_to_non_nullable
as int,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,corporation: null == corporation ? _self.corporation : corporation // ignore: cast_nullable_to_non_nullable
as String,createAt: null == createAt ? _self.createAt : createAt // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Notice implements Notice {
  const _Notice({required this.id, required this.seq, required this.title, required this.regDate, required this.hits, required this.department, required this.corporation, required this.createAt, this.content, this.summary});
  factory _Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);

@override final  String id;
@override final  String seq;
@override final  String title;
@override final  String regDate;
@override final  int hits;
@override final  String department;
@override final  String corporation;
@override final  String createAt;
@override final  String? content;
@override final  String? summary;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Notice&&(identical(other.id, id) || other.id == id)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.title, title) || other.title == title)&&(identical(other.regDate, regDate) || other.regDate == regDate)&&(identical(other.hits, hits) || other.hits == hits)&&(identical(other.department, department) || other.department == department)&&(identical(other.corporation, corporation) || other.corporation == corporation)&&(identical(other.createAt, createAt) || other.createAt == createAt)&&(identical(other.content, content) || other.content == content)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seq,title,regDate,hits,department,corporation,createAt,content,summary);

@override
String toString() {
  return 'Notice(id: $id, seq: $seq, title: $title, regDate: $regDate, hits: $hits, department: $department, corporation: $corporation, createAt: $createAt, content: $content, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$NoticeCopyWith<$Res> implements $NoticeCopyWith<$Res> {
  factory _$NoticeCopyWith(_Notice value, $Res Function(_Notice) _then) = __$NoticeCopyWithImpl;
@override @useResult
$Res call({
 String id, String seq, String title, String regDate, int hits, String department, String corporation, String createAt, String? content, String? summary
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seq = null,Object? title = null,Object? regDate = null,Object? hits = null,Object? department = null,Object? corporation = null,Object? createAt = null,Object? content = freezed,Object? summary = freezed,}) {
  return _then(_Notice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,regDate: null == regDate ? _self.regDate : regDate // ignore: cast_nullable_to_non_nullable
as String,hits: null == hits ? _self.hits : hits // ignore: cast_nullable_to_non_nullable
as int,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,corporation: null == corporation ? _self.corporation : corporation // ignore: cast_nullable_to_non_nullable
as String,createAt: null == createAt ? _self.createAt : createAt // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
