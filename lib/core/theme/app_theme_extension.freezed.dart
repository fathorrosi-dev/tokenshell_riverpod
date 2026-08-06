// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_theme_extension.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppStatusColors {

 Color get success; Color get successForeground; Color get warning; Color get warningForeground; Color get info; Color get infoForeground; Color get error; Color get errorForeground;
/// Create a copy of AppStatusColors
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStatusColorsCopyWith<AppStatusColors> get copyWith => _$AppStatusColorsCopyWithImpl<AppStatusColors>(this as AppStatusColors, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppStatusColors&&(identical(other.success, success) || other.success == success)&&(identical(other.successForeground, successForeground) || other.successForeground == successForeground)&&(identical(other.warning, warning) || other.warning == warning)&&(identical(other.warningForeground, warningForeground) || other.warningForeground == warningForeground)&&(identical(other.info, info) || other.info == info)&&(identical(other.infoForeground, infoForeground) || other.infoForeground == infoForeground)&&(identical(other.error, error) || other.error == error)&&(identical(other.errorForeground, errorForeground) || other.errorForeground == errorForeground));
}


@override
int get hashCode => Object.hash(runtimeType,success,successForeground,warning,warningForeground,info,infoForeground,error,errorForeground);

@override
String toString() {
  return 'AppStatusColors(success: $success, successForeground: $successForeground, warning: $warning, warningForeground: $warningForeground, info: $info, infoForeground: $infoForeground, error: $error, errorForeground: $errorForeground)';
}


}

/// @nodoc
abstract mixin class $AppStatusColorsCopyWith<$Res>  {
  factory $AppStatusColorsCopyWith(AppStatusColors value, $Res Function(AppStatusColors) _then) = _$AppStatusColorsCopyWithImpl;
@useResult
$Res call({
 Color success, Color successForeground, Color warning, Color warningForeground, Color info, Color infoForeground, Color error, Color errorForeground
});




}
/// @nodoc
class _$AppStatusColorsCopyWithImpl<$Res>
    implements $AppStatusColorsCopyWith<$Res> {
  _$AppStatusColorsCopyWithImpl(this._self, this._then);

  final AppStatusColors _self;
  final $Res Function(AppStatusColors) _then;

/// Create a copy of AppStatusColors
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? successForeground = null,Object? warning = null,Object? warningForeground = null,Object? info = null,Object? infoForeground = null,Object? error = null,Object? errorForeground = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as Color,successForeground: null == successForeground ? _self.successForeground : successForeground // ignore: cast_nullable_to_non_nullable
as Color,warning: null == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as Color,warningForeground: null == warningForeground ? _self.warningForeground : warningForeground // ignore: cast_nullable_to_non_nullable
as Color,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Color,infoForeground: null == infoForeground ? _self.infoForeground : infoForeground // ignore: cast_nullable_to_non_nullable
as Color,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Color,errorForeground: null == errorForeground ? _self.errorForeground : errorForeground // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}

}


/// Adds pattern-matching-related methods to [AppStatusColors].
extension AppStatusColorsPatterns on AppStatusColors {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppStatusColors value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppStatusColors() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppStatusColors value)  $default,){
final _that = this;
switch (_that) {
case _AppStatusColors():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppStatusColors value)?  $default,){
final _that = this;
switch (_that) {
case _AppStatusColors() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Color success,  Color successForeground,  Color warning,  Color warningForeground,  Color info,  Color infoForeground,  Color error,  Color errorForeground)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppStatusColors() when $default != null:
return $default(_that.success,_that.successForeground,_that.warning,_that.warningForeground,_that.info,_that.infoForeground,_that.error,_that.errorForeground);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Color success,  Color successForeground,  Color warning,  Color warningForeground,  Color info,  Color infoForeground,  Color error,  Color errorForeground)  $default,) {final _that = this;
switch (_that) {
case _AppStatusColors():
return $default(_that.success,_that.successForeground,_that.warning,_that.warningForeground,_that.info,_that.infoForeground,_that.error,_that.errorForeground);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Color success,  Color successForeground,  Color warning,  Color warningForeground,  Color info,  Color infoForeground,  Color error,  Color errorForeground)?  $default,) {final _that = this;
switch (_that) {
case _AppStatusColors() when $default != null:
return $default(_that.success,_that.successForeground,_that.warning,_that.warningForeground,_that.info,_that.infoForeground,_that.error,_that.errorForeground);case _:
  return null;

}
}

}

/// @nodoc


class _AppStatusColors implements AppStatusColors {
  const _AppStatusColors({required this.success, required this.successForeground, required this.warning, required this.warningForeground, required this.info, required this.infoForeground, required this.error, required this.errorForeground});
  

@override final  Color success;
@override final  Color successForeground;
@override final  Color warning;
@override final  Color warningForeground;
@override final  Color info;
@override final  Color infoForeground;
@override final  Color error;
@override final  Color errorForeground;

/// Create a copy of AppStatusColors
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStatusColorsCopyWith<_AppStatusColors> get copyWith => __$AppStatusColorsCopyWithImpl<_AppStatusColors>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppStatusColors&&(identical(other.success, success) || other.success == success)&&(identical(other.successForeground, successForeground) || other.successForeground == successForeground)&&(identical(other.warning, warning) || other.warning == warning)&&(identical(other.warningForeground, warningForeground) || other.warningForeground == warningForeground)&&(identical(other.info, info) || other.info == info)&&(identical(other.infoForeground, infoForeground) || other.infoForeground == infoForeground)&&(identical(other.error, error) || other.error == error)&&(identical(other.errorForeground, errorForeground) || other.errorForeground == errorForeground));
}


@override
int get hashCode => Object.hash(runtimeType,success,successForeground,warning,warningForeground,info,infoForeground,error,errorForeground);

@override
String toString() {
  return 'AppStatusColors(success: $success, successForeground: $successForeground, warning: $warning, warningForeground: $warningForeground, info: $info, infoForeground: $infoForeground, error: $error, errorForeground: $errorForeground)';
}


}

/// @nodoc
abstract mixin class _$AppStatusColorsCopyWith<$Res> implements $AppStatusColorsCopyWith<$Res> {
  factory _$AppStatusColorsCopyWith(_AppStatusColors value, $Res Function(_AppStatusColors) _then) = __$AppStatusColorsCopyWithImpl;
@override @useResult
$Res call({
 Color success, Color successForeground, Color warning, Color warningForeground, Color info, Color infoForeground, Color error, Color errorForeground
});




}
/// @nodoc
class __$AppStatusColorsCopyWithImpl<$Res>
    implements _$AppStatusColorsCopyWith<$Res> {
  __$AppStatusColorsCopyWithImpl(this._self, this._then);

  final _AppStatusColors _self;
  final $Res Function(_AppStatusColors) _then;

/// Create a copy of AppStatusColors
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? successForeground = null,Object? warning = null,Object? warningForeground = null,Object? info = null,Object? infoForeground = null,Object? error = null,Object? errorForeground = null,}) {
  return _then(_AppStatusColors(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as Color,successForeground: null == successForeground ? _self.successForeground : successForeground // ignore: cast_nullable_to_non_nullable
as Color,warning: null == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as Color,warningForeground: null == warningForeground ? _self.warningForeground : warningForeground // ignore: cast_nullable_to_non_nullable
as Color,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Color,infoForeground: null == infoForeground ? _self.infoForeground : infoForeground // ignore: cast_nullable_to_non_nullable
as Color,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Color,errorForeground: null == errorForeground ? _self.errorForeground : errorForeground // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}


}

// dart format on
