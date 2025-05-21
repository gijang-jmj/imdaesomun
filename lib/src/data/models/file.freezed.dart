// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$File {

 String get fileName; String get fileLink; String? get fileId;
/// Create a copy of File
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileCopyWith<File> get copyWith => _$FileCopyWithImpl<File>(this as File, _$identity);

  /// Serializes this File to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is File&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileLink, fileLink) || other.fileLink == fileLink)&&(identical(other.fileId, fileId) || other.fileId == fileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,fileLink,fileId);

@override
String toString() {
  return 'File(fileName: $fileName, fileLink: $fileLink, fileId: $fileId)';
}


}

/// @nodoc
abstract mixin class $FileCopyWith<$Res>  {
  factory $FileCopyWith(File value, $Res Function(File) _then) = _$FileCopyWithImpl;
@useResult
$Res call({
 String fileName, String fileLink, String? fileId
});




}
/// @nodoc
class _$FileCopyWithImpl<$Res>
    implements $FileCopyWith<$Res> {
  _$FileCopyWithImpl(this._self, this._then);

  final File _self;
  final $Res Function(File) _then;

/// Create a copy of File
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? fileLink = null,Object? fileId = freezed,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileLink: null == fileLink ? _self.fileLink : fileLink // ignore: cast_nullable_to_non_nullable
as String,fileId: freezed == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _File implements File {
  const _File({required this.fileName, required this.fileLink, this.fileId});
  factory _File.fromJson(Map<String, dynamic> json) => _$FileFromJson(json);

@override final  String fileName;
@override final  String fileLink;
@override final  String? fileId;

/// Create a copy of File
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileCopyWith<_File> get copyWith => __$FileCopyWithImpl<_File>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _File&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileLink, fileLink) || other.fileLink == fileLink)&&(identical(other.fileId, fileId) || other.fileId == fileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,fileLink,fileId);

@override
String toString() {
  return 'File(fileName: $fileName, fileLink: $fileLink, fileId: $fileId)';
}


}

/// @nodoc
abstract mixin class _$FileCopyWith<$Res> implements $FileCopyWith<$Res> {
  factory _$FileCopyWith(_File value, $Res Function(_File) _then) = __$FileCopyWithImpl;
@override @useResult
$Res call({
 String fileName, String fileLink, String? fileId
});




}
/// @nodoc
class __$FileCopyWithImpl<$Res>
    implements _$FileCopyWith<$Res> {
  __$FileCopyWithImpl(this._self, this._then);

  final _File _self;
  final $Res Function(_File) _then;

/// Create a copy of File
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? fileLink = null,Object? fileId = freezed,}) {
  return _then(_File(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileLink: null == fileLink ? _self.fileLink : fileLink // ignore: cast_nullable_to_non_nullable
as String,fileId: freezed == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
