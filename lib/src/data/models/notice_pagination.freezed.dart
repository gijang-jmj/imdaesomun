// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_pagination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoticePagination {

 List<Notice> get notices; bool get hasMore; int get nextOffset; int get totalFetched; int get totalCount; int get shCount; int get ghCount;
/// Create a copy of NoticePagination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticePaginationCopyWith<NoticePagination> get copyWith => _$NoticePaginationCopyWithImpl<NoticePagination>(this as NoticePagination, _$identity);

  /// Serializes this NoticePagination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticePagination&&const DeepCollectionEquality().equals(other.notices, notices)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextOffset, nextOffset) || other.nextOffset == nextOffset)&&(identical(other.totalFetched, totalFetched) || other.totalFetched == totalFetched)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.shCount, shCount) || other.shCount == shCount)&&(identical(other.ghCount, ghCount) || other.ghCount == ghCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(notices),hasMore,nextOffset,totalFetched,totalCount,shCount,ghCount);

@override
String toString() {
  return 'NoticePagination(notices: $notices, hasMore: $hasMore, nextOffset: $nextOffset, totalFetched: $totalFetched, totalCount: $totalCount, shCount: $shCount, ghCount: $ghCount)';
}


}

/// @nodoc
abstract mixin class $NoticePaginationCopyWith<$Res>  {
  factory $NoticePaginationCopyWith(NoticePagination value, $Res Function(NoticePagination) _then) = _$NoticePaginationCopyWithImpl;
@useResult
$Res call({
 List<Notice> notices, bool hasMore, int nextOffset, int totalFetched, int totalCount, int shCount, int ghCount
});




}
/// @nodoc
class _$NoticePaginationCopyWithImpl<$Res>
    implements $NoticePaginationCopyWith<$Res> {
  _$NoticePaginationCopyWithImpl(this._self, this._then);

  final NoticePagination _self;
  final $Res Function(NoticePagination) _then;

/// Create a copy of NoticePagination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notices = null,Object? hasMore = null,Object? nextOffset = null,Object? totalFetched = null,Object? totalCount = null,Object? shCount = null,Object? ghCount = null,}) {
  return _then(_self.copyWith(
notices: null == notices ? _self.notices : notices // ignore: cast_nullable_to_non_nullable
as List<Notice>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextOffset: null == nextOffset ? _self.nextOffset : nextOffset // ignore: cast_nullable_to_non_nullable
as int,totalFetched: null == totalFetched ? _self.totalFetched : totalFetched // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,shCount: null == shCount ? _self.shCount : shCount // ignore: cast_nullable_to_non_nullable
as int,ghCount: null == ghCount ? _self.ghCount : ghCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _NoticePagination implements NoticePagination {
  const _NoticePagination({required final  List<Notice> notices, required this.hasMore, required this.nextOffset, required this.totalFetched, required this.totalCount, required this.shCount, required this.ghCount}): _notices = notices;
  factory _NoticePagination.fromJson(Map<String, dynamic> json) => _$NoticePaginationFromJson(json);

 final  List<Notice> _notices;
@override List<Notice> get notices {
  if (_notices is EqualUnmodifiableListView) return _notices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notices);
}

@override final  bool hasMore;
@override final  int nextOffset;
@override final  int totalFetched;
@override final  int totalCount;
@override final  int shCount;
@override final  int ghCount;

/// Create a copy of NoticePagination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticePaginationCopyWith<_NoticePagination> get copyWith => __$NoticePaginationCopyWithImpl<_NoticePagination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticePaginationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticePagination&&const DeepCollectionEquality().equals(other._notices, _notices)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextOffset, nextOffset) || other.nextOffset == nextOffset)&&(identical(other.totalFetched, totalFetched) || other.totalFetched == totalFetched)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.shCount, shCount) || other.shCount == shCount)&&(identical(other.ghCount, ghCount) || other.ghCount == ghCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_notices),hasMore,nextOffset,totalFetched,totalCount,shCount,ghCount);

@override
String toString() {
  return 'NoticePagination(notices: $notices, hasMore: $hasMore, nextOffset: $nextOffset, totalFetched: $totalFetched, totalCount: $totalCount, shCount: $shCount, ghCount: $ghCount)';
}


}

/// @nodoc
abstract mixin class _$NoticePaginationCopyWith<$Res> implements $NoticePaginationCopyWith<$Res> {
  factory _$NoticePaginationCopyWith(_NoticePagination value, $Res Function(_NoticePagination) _then) = __$NoticePaginationCopyWithImpl;
@override @useResult
$Res call({
 List<Notice> notices, bool hasMore, int nextOffset, int totalFetched, int totalCount, int shCount, int ghCount
});




}
/// @nodoc
class __$NoticePaginationCopyWithImpl<$Res>
    implements _$NoticePaginationCopyWith<$Res> {
  __$NoticePaginationCopyWithImpl(this._self, this._then);

  final _NoticePagination _self;
  final $Res Function(_NoticePagination) _then;

/// Create a copy of NoticePagination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notices = null,Object? hasMore = null,Object? nextOffset = null,Object? totalFetched = null,Object? totalCount = null,Object? shCount = null,Object? ghCount = null,}) {
  return _then(_NoticePagination(
notices: null == notices ? _self._notices : notices // ignore: cast_nullable_to_non_nullable
as List<Notice>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextOffset: null == nextOffset ? _self.nextOffset : nextOffset // ignore: cast_nullable_to_non_nullable
as int,totalFetched: null == totalFetched ? _self.totalFetched : totalFetched // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,shCount: null == shCount ? _self.shCount : shCount // ignore: cast_nullable_to_non_nullable
as int,ghCount: null == ghCount ? _self.ghCount : ghCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
