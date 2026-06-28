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

/// @nodoc
mixin _$AppThemeColors {

// ── Core semantic tokens ─────────────────────────────────────────────────
 Color get background; Color get foreground; Color get card; Color get cardForeground; Color get popover; Color get popoverForeground; Color get primary; Color get primaryForeground; Color get secondary; Color get secondaryForeground; Color get muted; Color get mutedForeground; Color get accent; Color get accentForeground; Color get destructive; Color get destructiveForeground; Color get border; Color get input; Color get ring;// ── Status tokens (grouped) ───────────────────────────────────────────────
 AppStatusColors get status;
/// Create a copy of AppThemeColors
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppThemeColorsCopyWith<AppThemeColors> get copyWith => _$AppThemeColorsCopyWithImpl<AppThemeColors>(this as AppThemeColors, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppThemeColors&&(identical(other.background, background) || other.background == background)&&(identical(other.foreground, foreground) || other.foreground == foreground)&&(identical(other.card, card) || other.card == card)&&(identical(other.cardForeground, cardForeground) || other.cardForeground == cardForeground)&&(identical(other.popover, popover) || other.popover == popover)&&(identical(other.popoverForeground, popoverForeground) || other.popoverForeground == popoverForeground)&&(identical(other.primary, primary) || other.primary == primary)&&(identical(other.primaryForeground, primaryForeground) || other.primaryForeground == primaryForeground)&&(identical(other.secondary, secondary) || other.secondary == secondary)&&(identical(other.secondaryForeground, secondaryForeground) || other.secondaryForeground == secondaryForeground)&&(identical(other.muted, muted) || other.muted == muted)&&(identical(other.mutedForeground, mutedForeground) || other.mutedForeground == mutedForeground)&&(identical(other.accent, accent) || other.accent == accent)&&(identical(other.accentForeground, accentForeground) || other.accentForeground == accentForeground)&&(identical(other.destructive, destructive) || other.destructive == destructive)&&(identical(other.destructiveForeground, destructiveForeground) || other.destructiveForeground == destructiveForeground)&&(identical(other.border, border) || other.border == border)&&(identical(other.input, input) || other.input == input)&&(identical(other.ring, ring) || other.ring == ring)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hashAll([runtimeType,background,foreground,card,cardForeground,popover,popoverForeground,primary,primaryForeground,secondary,secondaryForeground,muted,mutedForeground,accent,accentForeground,destructive,destructiveForeground,border,input,ring,status]);

@override
String toString() {
  return 'AppThemeColors(background: $background, foreground: $foreground, card: $card, cardForeground: $cardForeground, popover: $popover, popoverForeground: $popoverForeground, primary: $primary, primaryForeground: $primaryForeground, secondary: $secondary, secondaryForeground: $secondaryForeground, muted: $muted, mutedForeground: $mutedForeground, accent: $accent, accentForeground: $accentForeground, destructive: $destructive, destructiveForeground: $destructiveForeground, border: $border, input: $input, ring: $ring, status: $status)';
}


}

/// @nodoc
abstract mixin class $AppThemeColorsCopyWith<$Res>  {
  factory $AppThemeColorsCopyWith(AppThemeColors value, $Res Function(AppThemeColors) _then) = _$AppThemeColorsCopyWithImpl;
@useResult
$Res call({
 Color background, Color foreground, Color card, Color cardForeground, Color popover, Color popoverForeground, Color primary, Color primaryForeground, Color secondary, Color secondaryForeground, Color muted, Color mutedForeground, Color accent, Color accentForeground, Color destructive, Color destructiveForeground, Color border, Color input, Color ring, AppStatusColors status
});


$AppStatusColorsCopyWith<$Res> get status;

}
/// @nodoc
class _$AppThemeColorsCopyWithImpl<$Res>
    implements $AppThemeColorsCopyWith<$Res> {
  _$AppThemeColorsCopyWithImpl(this._self, this._then);

  final AppThemeColors _self;
  final $Res Function(AppThemeColors) _then;

/// Create a copy of AppThemeColors
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? background = null,Object? foreground = null,Object? card = null,Object? cardForeground = null,Object? popover = null,Object? popoverForeground = null,Object? primary = null,Object? primaryForeground = null,Object? secondary = null,Object? secondaryForeground = null,Object? muted = null,Object? mutedForeground = null,Object? accent = null,Object? accentForeground = null,Object? destructive = null,Object? destructiveForeground = null,Object? border = null,Object? input = null,Object? ring = null,Object? status = null,}) {
  return _then(_self.copyWith(
background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as Color,foreground: null == foreground ? _self.foreground : foreground // ignore: cast_nullable_to_non_nullable
as Color,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as Color,cardForeground: null == cardForeground ? _self.cardForeground : cardForeground // ignore: cast_nullable_to_non_nullable
as Color,popover: null == popover ? _self.popover : popover // ignore: cast_nullable_to_non_nullable
as Color,popoverForeground: null == popoverForeground ? _self.popoverForeground : popoverForeground // ignore: cast_nullable_to_non_nullable
as Color,primary: null == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as Color,primaryForeground: null == primaryForeground ? _self.primaryForeground : primaryForeground // ignore: cast_nullable_to_non_nullable
as Color,secondary: null == secondary ? _self.secondary : secondary // ignore: cast_nullable_to_non_nullable
as Color,secondaryForeground: null == secondaryForeground ? _self.secondaryForeground : secondaryForeground // ignore: cast_nullable_to_non_nullable
as Color,muted: null == muted ? _self.muted : muted // ignore: cast_nullable_to_non_nullable
as Color,mutedForeground: null == mutedForeground ? _self.mutedForeground : mutedForeground // ignore: cast_nullable_to_non_nullable
as Color,accent: null == accent ? _self.accent : accent // ignore: cast_nullable_to_non_nullable
as Color,accentForeground: null == accentForeground ? _self.accentForeground : accentForeground // ignore: cast_nullable_to_non_nullable
as Color,destructive: null == destructive ? _self.destructive : destructive // ignore: cast_nullable_to_non_nullable
as Color,destructiveForeground: null == destructiveForeground ? _self.destructiveForeground : destructiveForeground // ignore: cast_nullable_to_non_nullable
as Color,border: null == border ? _self.border : border // ignore: cast_nullable_to_non_nullable
as Color,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as Color,ring: null == ring ? _self.ring : ring // ignore: cast_nullable_to_non_nullable
as Color,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppStatusColors,
  ));
}
/// Create a copy of AppThemeColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppStatusColorsCopyWith<$Res> get status {
  
  return $AppStatusColorsCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppThemeColors].
extension AppThemeColorsPatterns on AppThemeColors {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppThemeColors value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppThemeColors() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppThemeColors value)  $default,){
final _that = this;
switch (_that) {
case _AppThemeColors():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppThemeColors value)?  $default,){
final _that = this;
switch (_that) {
case _AppThemeColors() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Color background,  Color foreground,  Color card,  Color cardForeground,  Color popover,  Color popoverForeground,  Color primary,  Color primaryForeground,  Color secondary,  Color secondaryForeground,  Color muted,  Color mutedForeground,  Color accent,  Color accentForeground,  Color destructive,  Color destructiveForeground,  Color border,  Color input,  Color ring,  AppStatusColors status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppThemeColors() when $default != null:
return $default(_that.background,_that.foreground,_that.card,_that.cardForeground,_that.popover,_that.popoverForeground,_that.primary,_that.primaryForeground,_that.secondary,_that.secondaryForeground,_that.muted,_that.mutedForeground,_that.accent,_that.accentForeground,_that.destructive,_that.destructiveForeground,_that.border,_that.input,_that.ring,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Color background,  Color foreground,  Color card,  Color cardForeground,  Color popover,  Color popoverForeground,  Color primary,  Color primaryForeground,  Color secondary,  Color secondaryForeground,  Color muted,  Color mutedForeground,  Color accent,  Color accentForeground,  Color destructive,  Color destructiveForeground,  Color border,  Color input,  Color ring,  AppStatusColors status)  $default,) {final _that = this;
switch (_that) {
case _AppThemeColors():
return $default(_that.background,_that.foreground,_that.card,_that.cardForeground,_that.popover,_that.popoverForeground,_that.primary,_that.primaryForeground,_that.secondary,_that.secondaryForeground,_that.muted,_that.mutedForeground,_that.accent,_that.accentForeground,_that.destructive,_that.destructiveForeground,_that.border,_that.input,_that.ring,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Color background,  Color foreground,  Color card,  Color cardForeground,  Color popover,  Color popoverForeground,  Color primary,  Color primaryForeground,  Color secondary,  Color secondaryForeground,  Color muted,  Color mutedForeground,  Color accent,  Color accentForeground,  Color destructive,  Color destructiveForeground,  Color border,  Color input,  Color ring,  AppStatusColors status)?  $default,) {final _that = this;
switch (_that) {
case _AppThemeColors() when $default != null:
return $default(_that.background,_that.foreground,_that.card,_that.cardForeground,_that.popover,_that.popoverForeground,_that.primary,_that.primaryForeground,_that.secondary,_that.secondaryForeground,_that.muted,_that.mutedForeground,_that.accent,_that.accentForeground,_that.destructive,_that.destructiveForeground,_that.border,_that.input,_that.ring,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _AppThemeColors implements AppThemeColors {
  const _AppThemeColors({required this.background, required this.foreground, required this.card, required this.cardForeground, required this.popover, required this.popoverForeground, required this.primary, required this.primaryForeground, required this.secondary, required this.secondaryForeground, required this.muted, required this.mutedForeground, required this.accent, required this.accentForeground, required this.destructive, required this.destructiveForeground, required this.border, required this.input, required this.ring, required this.status});
  

// ── Core semantic tokens ─────────────────────────────────────────────────
@override final  Color background;
@override final  Color foreground;
@override final  Color card;
@override final  Color cardForeground;
@override final  Color popover;
@override final  Color popoverForeground;
@override final  Color primary;
@override final  Color primaryForeground;
@override final  Color secondary;
@override final  Color secondaryForeground;
@override final  Color muted;
@override final  Color mutedForeground;
@override final  Color accent;
@override final  Color accentForeground;
@override final  Color destructive;
@override final  Color destructiveForeground;
@override final  Color border;
@override final  Color input;
@override final  Color ring;
// ── Status tokens (grouped) ───────────────────────────────────────────────
@override final  AppStatusColors status;

/// Create a copy of AppThemeColors
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppThemeColorsCopyWith<_AppThemeColors> get copyWith => __$AppThemeColorsCopyWithImpl<_AppThemeColors>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppThemeColors&&(identical(other.background, background) || other.background == background)&&(identical(other.foreground, foreground) || other.foreground == foreground)&&(identical(other.card, card) || other.card == card)&&(identical(other.cardForeground, cardForeground) || other.cardForeground == cardForeground)&&(identical(other.popover, popover) || other.popover == popover)&&(identical(other.popoverForeground, popoverForeground) || other.popoverForeground == popoverForeground)&&(identical(other.primary, primary) || other.primary == primary)&&(identical(other.primaryForeground, primaryForeground) || other.primaryForeground == primaryForeground)&&(identical(other.secondary, secondary) || other.secondary == secondary)&&(identical(other.secondaryForeground, secondaryForeground) || other.secondaryForeground == secondaryForeground)&&(identical(other.muted, muted) || other.muted == muted)&&(identical(other.mutedForeground, mutedForeground) || other.mutedForeground == mutedForeground)&&(identical(other.accent, accent) || other.accent == accent)&&(identical(other.accentForeground, accentForeground) || other.accentForeground == accentForeground)&&(identical(other.destructive, destructive) || other.destructive == destructive)&&(identical(other.destructiveForeground, destructiveForeground) || other.destructiveForeground == destructiveForeground)&&(identical(other.border, border) || other.border == border)&&(identical(other.input, input) || other.input == input)&&(identical(other.ring, ring) || other.ring == ring)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hashAll([runtimeType,background,foreground,card,cardForeground,popover,popoverForeground,primary,primaryForeground,secondary,secondaryForeground,muted,mutedForeground,accent,accentForeground,destructive,destructiveForeground,border,input,ring,status]);

@override
String toString() {
  return 'AppThemeColors(background: $background, foreground: $foreground, card: $card, cardForeground: $cardForeground, popover: $popover, popoverForeground: $popoverForeground, primary: $primary, primaryForeground: $primaryForeground, secondary: $secondary, secondaryForeground: $secondaryForeground, muted: $muted, mutedForeground: $mutedForeground, accent: $accent, accentForeground: $accentForeground, destructive: $destructive, destructiveForeground: $destructiveForeground, border: $border, input: $input, ring: $ring, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AppThemeColorsCopyWith<$Res> implements $AppThemeColorsCopyWith<$Res> {
  factory _$AppThemeColorsCopyWith(_AppThemeColors value, $Res Function(_AppThemeColors) _then) = __$AppThemeColorsCopyWithImpl;
@override @useResult
$Res call({
 Color background, Color foreground, Color card, Color cardForeground, Color popover, Color popoverForeground, Color primary, Color primaryForeground, Color secondary, Color secondaryForeground, Color muted, Color mutedForeground, Color accent, Color accentForeground, Color destructive, Color destructiveForeground, Color border, Color input, Color ring, AppStatusColors status
});


@override $AppStatusColorsCopyWith<$Res> get status;

}
/// @nodoc
class __$AppThemeColorsCopyWithImpl<$Res>
    implements _$AppThemeColorsCopyWith<$Res> {
  __$AppThemeColorsCopyWithImpl(this._self, this._then);

  final _AppThemeColors _self;
  final $Res Function(_AppThemeColors) _then;

/// Create a copy of AppThemeColors
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? background = null,Object? foreground = null,Object? card = null,Object? cardForeground = null,Object? popover = null,Object? popoverForeground = null,Object? primary = null,Object? primaryForeground = null,Object? secondary = null,Object? secondaryForeground = null,Object? muted = null,Object? mutedForeground = null,Object? accent = null,Object? accentForeground = null,Object? destructive = null,Object? destructiveForeground = null,Object? border = null,Object? input = null,Object? ring = null,Object? status = null,}) {
  return _then(_AppThemeColors(
background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as Color,foreground: null == foreground ? _self.foreground : foreground // ignore: cast_nullable_to_non_nullable
as Color,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as Color,cardForeground: null == cardForeground ? _self.cardForeground : cardForeground // ignore: cast_nullable_to_non_nullable
as Color,popover: null == popover ? _self.popover : popover // ignore: cast_nullable_to_non_nullable
as Color,popoverForeground: null == popoverForeground ? _self.popoverForeground : popoverForeground // ignore: cast_nullable_to_non_nullable
as Color,primary: null == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as Color,primaryForeground: null == primaryForeground ? _self.primaryForeground : primaryForeground // ignore: cast_nullable_to_non_nullable
as Color,secondary: null == secondary ? _self.secondary : secondary // ignore: cast_nullable_to_non_nullable
as Color,secondaryForeground: null == secondaryForeground ? _self.secondaryForeground : secondaryForeground // ignore: cast_nullable_to_non_nullable
as Color,muted: null == muted ? _self.muted : muted // ignore: cast_nullable_to_non_nullable
as Color,mutedForeground: null == mutedForeground ? _self.mutedForeground : mutedForeground // ignore: cast_nullable_to_non_nullable
as Color,accent: null == accent ? _self.accent : accent // ignore: cast_nullable_to_non_nullable
as Color,accentForeground: null == accentForeground ? _self.accentForeground : accentForeground // ignore: cast_nullable_to_non_nullable
as Color,destructive: null == destructive ? _self.destructive : destructive // ignore: cast_nullable_to_non_nullable
as Color,destructiveForeground: null == destructiveForeground ? _self.destructiveForeground : destructiveForeground // ignore: cast_nullable_to_non_nullable
as Color,border: null == border ? _self.border : border // ignore: cast_nullable_to_non_nullable
as Color,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as Color,ring: null == ring ? _self.ring : ring // ignore: cast_nullable_to_non_nullable
as Color,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppStatusColors,
  ));
}

/// Create a copy of AppThemeColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppStatusColorsCopyWith<$Res> get status {
  
  return $AppStatusColorsCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

// dart format on
