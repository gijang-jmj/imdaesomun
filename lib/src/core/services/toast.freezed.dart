// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'toast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Toast {

 String get message; bool get isVisible; int get durationInSeconds;
/// Create a copy of Toast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToastCopyWith<Toast> get copyWith => _$ToastCopyWithImpl<Toast>(this as Toast, _$identity);

  /// Serializes this Toast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Toast&&(identical(other.message, message) || other.message == message)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.durationInSeconds, durationInSeconds) || other.durationInSeconds == durationInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,isVisible,durationInSeconds);

@override
String toString() {
  return 'Toast(message: $message, isVisible: $isVisible, durationInSeconds: $durationInSeconds)';
}


}

/// @nodoc
abstract mixin class $ToastCopyWith<$Res>  {
  factory $ToastCopyWith(Toast value, $Res Function(Toast) _then) = _$ToastCopyWithImpl;
@useResult
$Res call({
 String message, bool isVisible, int durationInSeconds
});




}
/// @nodoc
class _$ToastCopyWithImpl<$Res>
    implements $ToastCopyWith<$Res> {
  _$ToastCopyWithImpl(this._self, this._then);

  final Toast _self;
  final $Res Function(Toast) _then;

/// Create a copy of Toast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? isVisible = null,Object? durationInSeconds = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,durationInSeconds: null == durationInSeconds ? _self.durationInSeconds : durationInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Toast implements Toast {
   _Toast({required this.message, this.isVisible = false, this.durationInSeconds = 3});
  factory _Toast.fromJson(Map<String, dynamic> json) => _$ToastFromJson(json);

@override final  String message;
@override@JsonKey() final  bool isVisible;
@override@JsonKey() final  int durationInSeconds;

/// Create a copy of Toast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToastCopyWith<_Toast> get copyWith => __$ToastCopyWithImpl<_Toast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ToastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Toast&&(identical(other.message, message) || other.message == message)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.durationInSeconds, durationInSeconds) || other.durationInSeconds == durationInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,isVisible,durationInSeconds);

@override
String toString() {
  return 'Toast(message: $message, isVisible: $isVisible, durationInSeconds: $durationInSeconds)';
}


}

/// @nodoc
abstract mixin class _$ToastCopyWith<$Res> implements $ToastCopyWith<$Res> {
  factory _$ToastCopyWith(_Toast value, $Res Function(_Toast) _then) = __$ToastCopyWithImpl;
@override @useResult
$Res call({
 String message, bool isVisible, int durationInSeconds
});




}
/// @nodoc
class __$ToastCopyWithImpl<$Res>
    implements _$ToastCopyWith<$Res> {
  __$ToastCopyWithImpl(this._self, this._then);

  final _Toast _self;
  final $Res Function(_Toast) _then;

/// Create a copy of Toast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isVisible = null,Object? durationInSeconds = null,}) {
  return _then(_Toast(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,durationInSeconds: null == durationInSeconds ? _self.durationInSeconds : durationInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
