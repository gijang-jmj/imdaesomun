// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoticePageState {

 String get id; bool get isSaved; Notice? get notice;
/// Create a copy of NoticePageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticePageStateCopyWith<NoticePageState> get copyWith => _$NoticePageStateCopyWithImpl<NoticePageState>(this as NoticePageState, _$identity);

  /// Serializes this NoticePageState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticePageState&&(identical(other.id, id) || other.id == id)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.notice, notice) || other.notice == notice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isSaved,notice);

@override
String toString() {
  return 'NoticePageState(id: $id, isSaved: $isSaved, notice: $notice)';
}


}

/// @nodoc
abstract mixin class $NoticePageStateCopyWith<$Res>  {
  factory $NoticePageStateCopyWith(NoticePageState value, $Res Function(NoticePageState) _then) = _$NoticePageStateCopyWithImpl;
@useResult
$Res call({
 String id, bool isSaved, Notice? notice
});


$NoticeCopyWith<$Res>? get notice;

}
/// @nodoc
class _$NoticePageStateCopyWithImpl<$Res>
    implements $NoticePageStateCopyWith<$Res> {
  _$NoticePageStateCopyWithImpl(this._self, this._then);

  final NoticePageState _self;
  final $Res Function(NoticePageState) _then;

/// Create a copy of NoticePageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isSaved = null,Object? notice = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as Notice?,
  ));
}
/// Create a copy of NoticePageState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeCopyWith<$Res>? get notice {
    if (_self.notice == null) {
    return null;
  }

  return $NoticeCopyWith<$Res>(_self.notice!, (value) {
    return _then(_self.copyWith(notice: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _NoticePageState implements NoticePageState {
  const _NoticePageState({required this.id, required this.isSaved, this.notice});
  factory _NoticePageState.fromJson(Map<String, dynamic> json) => _$NoticePageStateFromJson(json);

@override final  String id;
@override final  bool isSaved;
@override final  Notice? notice;

/// Create a copy of NoticePageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticePageStateCopyWith<_NoticePageState> get copyWith => __$NoticePageStateCopyWithImpl<_NoticePageState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticePageStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticePageState&&(identical(other.id, id) || other.id == id)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.notice, notice) || other.notice == notice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isSaved,notice);

@override
String toString() {
  return 'NoticePageState(id: $id, isSaved: $isSaved, notice: $notice)';
}


}

/// @nodoc
abstract mixin class _$NoticePageStateCopyWith<$Res> implements $NoticePageStateCopyWith<$Res> {
  factory _$NoticePageStateCopyWith(_NoticePageState value, $Res Function(_NoticePageState) _then) = __$NoticePageStateCopyWithImpl;
@override @useResult
$Res call({
 String id, bool isSaved, Notice? notice
});


@override $NoticeCopyWith<$Res>? get notice;

}
/// @nodoc
class __$NoticePageStateCopyWithImpl<$Res>
    implements _$NoticePageStateCopyWith<$Res> {
  __$NoticePageStateCopyWithImpl(this._self, this._then);

  final _NoticePageState _self;
  final $Res Function(_NoticePageState) _then;

/// Create a copy of NoticePageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isSaved = null,Object? notice = freezed,}) {
  return _then(_NoticePageState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as Notice?,
  ));
}

/// Create a copy of NoticePageState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeCopyWith<$Res>? get notice {
    if (_self.notice == null) {
    return null;
  }

  return $NoticeCopyWith<$Res>(_self.notice!, (value) {
    return _then(_self.copyWith(notice: value));
  });
}
}

// dart format on
