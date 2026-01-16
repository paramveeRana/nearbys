// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NetworkExceptions implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkExceptions);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions()';
}


}

/// @nodoc
class $NetworkExceptionsCopyWith<$Res>  {
$NetworkExceptionsCopyWith(NetworkExceptions _, $Res Function(NetworkExceptions) __);
}


/// Adds pattern-matching-related methods to [NetworkExceptions].
extension NetworkExceptionsPatterns on NetworkExceptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RequestCancelled value)?  requestCancelled,TResult Function( UnauthorizedRequest value)?  unauthorizedRequest,TResult Function( BadRequest value)?  badRequest,TResult Function( NotFound value)?  notFound,TResult Function( MethodNotAllowed value)?  methodNotAllowed,TResult Function( NotAcceptable value)?  notAcceptable,TResult Function( RequestTimeout value)?  requestTimeout,TResult Function( SendTimeout value)?  sendTimeout,TResult Function( Conflict value)?  conflict,TResult Function( InternalServerError value)?  internalServerError,TResult Function( NotImplemented value)?  notImplemented,TResult Function( ServiceUnavailable value)?  serviceUnavailable,TResult Function( NoInternetConnection value)?  noInternetConnection,TResult Function( FormatException value)?  formatException,TResult Function( UnableToProcess value)?  unableToProcess,TResult Function( DefaultError value)?  defaultError,TResult Function( UnexpectedError value)?  unexpectedError,TResult Function( BadCertificate value)?  badCertificate,TResult Function( ConnectionError value)?  connectionError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RequestCancelled() when requestCancelled != null:
return requestCancelled(_that);case UnauthorizedRequest() when unauthorizedRequest != null:
return unauthorizedRequest(_that);case BadRequest() when badRequest != null:
return badRequest(_that);case NotFound() when notFound != null:
return notFound(_that);case MethodNotAllowed() when methodNotAllowed != null:
return methodNotAllowed(_that);case NotAcceptable() when notAcceptable != null:
return notAcceptable(_that);case RequestTimeout() when requestTimeout != null:
return requestTimeout(_that);case SendTimeout() when sendTimeout != null:
return sendTimeout(_that);case Conflict() when conflict != null:
return conflict(_that);case InternalServerError() when internalServerError != null:
return internalServerError(_that);case NotImplemented() when notImplemented != null:
return notImplemented(_that);case ServiceUnavailable() when serviceUnavailable != null:
return serviceUnavailable(_that);case NoInternetConnection() when noInternetConnection != null:
return noInternetConnection(_that);case FormatException() when formatException != null:
return formatException(_that);case UnableToProcess() when unableToProcess != null:
return unableToProcess(_that);case DefaultError() when defaultError != null:
return defaultError(_that);case UnexpectedError() when unexpectedError != null:
return unexpectedError(_that);case BadCertificate() when badCertificate != null:
return badCertificate(_that);case ConnectionError() when connectionError != null:
return connectionError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RequestCancelled value)  requestCancelled,required TResult Function( UnauthorizedRequest value)  unauthorizedRequest,required TResult Function( BadRequest value)  badRequest,required TResult Function( NotFound value)  notFound,required TResult Function( MethodNotAllowed value)  methodNotAllowed,required TResult Function( NotAcceptable value)  notAcceptable,required TResult Function( RequestTimeout value)  requestTimeout,required TResult Function( SendTimeout value)  sendTimeout,required TResult Function( Conflict value)  conflict,required TResult Function( InternalServerError value)  internalServerError,required TResult Function( NotImplemented value)  notImplemented,required TResult Function( ServiceUnavailable value)  serviceUnavailable,required TResult Function( NoInternetConnection value)  noInternetConnection,required TResult Function( FormatException value)  formatException,required TResult Function( UnableToProcess value)  unableToProcess,required TResult Function( DefaultError value)  defaultError,required TResult Function( UnexpectedError value)  unexpectedError,required TResult Function( BadCertificate value)  badCertificate,required TResult Function( ConnectionError value)  connectionError,}){
final _that = this;
switch (_that) {
case RequestCancelled():
return requestCancelled(_that);case UnauthorizedRequest():
return unauthorizedRequest(_that);case BadRequest():
return badRequest(_that);case NotFound():
return notFound(_that);case MethodNotAllowed():
return methodNotAllowed(_that);case NotAcceptable():
return notAcceptable(_that);case RequestTimeout():
return requestTimeout(_that);case SendTimeout():
return sendTimeout(_that);case Conflict():
return conflict(_that);case InternalServerError():
return internalServerError(_that);case NotImplemented():
return notImplemented(_that);case ServiceUnavailable():
return serviceUnavailable(_that);case NoInternetConnection():
return noInternetConnection(_that);case FormatException():
return formatException(_that);case UnableToProcess():
return unableToProcess(_that);case DefaultError():
return defaultError(_that);case UnexpectedError():
return unexpectedError(_that);case BadCertificate():
return badCertificate(_that);case ConnectionError():
return connectionError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RequestCancelled value)?  requestCancelled,TResult? Function( UnauthorizedRequest value)?  unauthorizedRequest,TResult? Function( BadRequest value)?  badRequest,TResult? Function( NotFound value)?  notFound,TResult? Function( MethodNotAllowed value)?  methodNotAllowed,TResult? Function( NotAcceptable value)?  notAcceptable,TResult? Function( RequestTimeout value)?  requestTimeout,TResult? Function( SendTimeout value)?  sendTimeout,TResult? Function( Conflict value)?  conflict,TResult? Function( InternalServerError value)?  internalServerError,TResult? Function( NotImplemented value)?  notImplemented,TResult? Function( ServiceUnavailable value)?  serviceUnavailable,TResult? Function( NoInternetConnection value)?  noInternetConnection,TResult? Function( FormatException value)?  formatException,TResult? Function( UnableToProcess value)?  unableToProcess,TResult? Function( DefaultError value)?  defaultError,TResult? Function( UnexpectedError value)?  unexpectedError,TResult? Function( BadCertificate value)?  badCertificate,TResult? Function( ConnectionError value)?  connectionError,}){
final _that = this;
switch (_that) {
case RequestCancelled() when requestCancelled != null:
return requestCancelled(_that);case UnauthorizedRequest() when unauthorizedRequest != null:
return unauthorizedRequest(_that);case BadRequest() when badRequest != null:
return badRequest(_that);case NotFound() when notFound != null:
return notFound(_that);case MethodNotAllowed() when methodNotAllowed != null:
return methodNotAllowed(_that);case NotAcceptable() when notAcceptable != null:
return notAcceptable(_that);case RequestTimeout() when requestTimeout != null:
return requestTimeout(_that);case SendTimeout() when sendTimeout != null:
return sendTimeout(_that);case Conflict() when conflict != null:
return conflict(_that);case InternalServerError() when internalServerError != null:
return internalServerError(_that);case NotImplemented() when notImplemented != null:
return notImplemented(_that);case ServiceUnavailable() when serviceUnavailable != null:
return serviceUnavailable(_that);case NoInternetConnection() when noInternetConnection != null:
return noInternetConnection(_that);case FormatException() when formatException != null:
return formatException(_that);case UnableToProcess() when unableToProcess != null:
return unableToProcess(_that);case DefaultError() when defaultError != null:
return defaultError(_that);case UnexpectedError() when unexpectedError != null:
return unexpectedError(_that);case BadCertificate() when badCertificate != null:
return badCertificate(_that);case ConnectionError() when connectionError != null:
return connectionError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  requestCancelled,TResult Function()?  unauthorizedRequest,TResult Function()?  badRequest,TResult Function( String reason,  Response? response)?  notFound,TResult Function()?  methodNotAllowed,TResult Function()?  notAcceptable,TResult Function()?  requestTimeout,TResult Function()?  sendTimeout,TResult Function()?  conflict,TResult Function()?  internalServerError,TResult Function()?  notImplemented,TResult Function()?  serviceUnavailable,TResult Function()?  noInternetConnection,TResult Function()?  formatException,TResult Function()?  unableToProcess,TResult Function( String error)?  defaultError,TResult Function()?  unexpectedError,TResult Function()?  badCertificate,TResult Function()?  connectionError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RequestCancelled() when requestCancelled != null:
return requestCancelled();case UnauthorizedRequest() when unauthorizedRequest != null:
return unauthorizedRequest();case BadRequest() when badRequest != null:
return badRequest();case NotFound() when notFound != null:
return notFound(_that.reason,_that.response);case MethodNotAllowed() when methodNotAllowed != null:
return methodNotAllowed();case NotAcceptable() when notAcceptable != null:
return notAcceptable();case RequestTimeout() when requestTimeout != null:
return requestTimeout();case SendTimeout() when sendTimeout != null:
return sendTimeout();case Conflict() when conflict != null:
return conflict();case InternalServerError() when internalServerError != null:
return internalServerError();case NotImplemented() when notImplemented != null:
return notImplemented();case ServiceUnavailable() when serviceUnavailable != null:
return serviceUnavailable();case NoInternetConnection() when noInternetConnection != null:
return noInternetConnection();case FormatException() when formatException != null:
return formatException();case UnableToProcess() when unableToProcess != null:
return unableToProcess();case DefaultError() when defaultError != null:
return defaultError(_that.error);case UnexpectedError() when unexpectedError != null:
return unexpectedError();case BadCertificate() when badCertificate != null:
return badCertificate();case ConnectionError() when connectionError != null:
return connectionError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  requestCancelled,required TResult Function()  unauthorizedRequest,required TResult Function()  badRequest,required TResult Function( String reason,  Response? response)  notFound,required TResult Function()  methodNotAllowed,required TResult Function()  notAcceptable,required TResult Function()  requestTimeout,required TResult Function()  sendTimeout,required TResult Function()  conflict,required TResult Function()  internalServerError,required TResult Function()  notImplemented,required TResult Function()  serviceUnavailable,required TResult Function()  noInternetConnection,required TResult Function()  formatException,required TResult Function()  unableToProcess,required TResult Function( String error)  defaultError,required TResult Function()  unexpectedError,required TResult Function()  badCertificate,required TResult Function()  connectionError,}) {final _that = this;
switch (_that) {
case RequestCancelled():
return requestCancelled();case UnauthorizedRequest():
return unauthorizedRequest();case BadRequest():
return badRequest();case NotFound():
return notFound(_that.reason,_that.response);case MethodNotAllowed():
return methodNotAllowed();case NotAcceptable():
return notAcceptable();case RequestTimeout():
return requestTimeout();case SendTimeout():
return sendTimeout();case Conflict():
return conflict();case InternalServerError():
return internalServerError();case NotImplemented():
return notImplemented();case ServiceUnavailable():
return serviceUnavailable();case NoInternetConnection():
return noInternetConnection();case FormatException():
return formatException();case UnableToProcess():
return unableToProcess();case DefaultError():
return defaultError(_that.error);case UnexpectedError():
return unexpectedError();case BadCertificate():
return badCertificate();case ConnectionError():
return connectionError();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  requestCancelled,TResult? Function()?  unauthorizedRequest,TResult? Function()?  badRequest,TResult? Function( String reason,  Response? response)?  notFound,TResult? Function()?  methodNotAllowed,TResult? Function()?  notAcceptable,TResult? Function()?  requestTimeout,TResult? Function()?  sendTimeout,TResult? Function()?  conflict,TResult? Function()?  internalServerError,TResult? Function()?  notImplemented,TResult? Function()?  serviceUnavailable,TResult? Function()?  noInternetConnection,TResult? Function()?  formatException,TResult? Function()?  unableToProcess,TResult? Function( String error)?  defaultError,TResult? Function()?  unexpectedError,TResult? Function()?  badCertificate,TResult? Function()?  connectionError,}) {final _that = this;
switch (_that) {
case RequestCancelled() when requestCancelled != null:
return requestCancelled();case UnauthorizedRequest() when unauthorizedRequest != null:
return unauthorizedRequest();case BadRequest() when badRequest != null:
return badRequest();case NotFound() when notFound != null:
return notFound(_that.reason,_that.response);case MethodNotAllowed() when methodNotAllowed != null:
return methodNotAllowed();case NotAcceptable() when notAcceptable != null:
return notAcceptable();case RequestTimeout() when requestTimeout != null:
return requestTimeout();case SendTimeout() when sendTimeout != null:
return sendTimeout();case Conflict() when conflict != null:
return conflict();case InternalServerError() when internalServerError != null:
return internalServerError();case NotImplemented() when notImplemented != null:
return notImplemented();case ServiceUnavailable() when serviceUnavailable != null:
return serviceUnavailable();case NoInternetConnection() when noInternetConnection != null:
return noInternetConnection();case FormatException() when formatException != null:
return formatException();case UnableToProcess() when unableToProcess != null:
return unableToProcess();case DefaultError() when defaultError != null:
return defaultError(_that.error);case UnexpectedError() when unexpectedError != null:
return unexpectedError();case BadCertificate() when badCertificate != null:
return badCertificate();case ConnectionError() when connectionError != null:
return connectionError();case _:
  return null;

}
}

}

/// @nodoc


class RequestCancelled with DiagnosticableTreeMixin implements NetworkExceptions {
  const RequestCancelled();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.requestCancelled'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.requestCancelled()';
}


}




/// @nodoc


class UnauthorizedRequest with DiagnosticableTreeMixin implements NetworkExceptions {
  const UnauthorizedRequest();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.unauthorizedRequest'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedRequest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.unauthorizedRequest()';
}


}




/// @nodoc


class BadRequest with DiagnosticableTreeMixin implements NetworkExceptions {
  const BadRequest();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.badRequest'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadRequest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.badRequest()';
}


}




/// @nodoc


class NotFound with DiagnosticableTreeMixin implements NetworkExceptions {
  const NotFound(this.reason, this.response);
  

 final  String reason;
 final  Response? response;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotFoundCopyWith<NotFound> get copyWith => _$NotFoundCopyWithImpl<NotFound>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.notFound'))
    ..add(DiagnosticsProperty('reason', reason))..add(DiagnosticsProperty('response', response));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFound&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,reason,response);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.notFound(reason: $reason, response: $response)';
}


}

/// @nodoc
abstract mixin class $NotFoundCopyWith<$Res> implements $NetworkExceptionsCopyWith<$Res> {
  factory $NotFoundCopyWith(NotFound value, $Res Function(NotFound) _then) = _$NotFoundCopyWithImpl;
@useResult
$Res call({
 String reason, Response? response
});




}
/// @nodoc
class _$NotFoundCopyWithImpl<$Res>
    implements $NotFoundCopyWith<$Res> {
  _$NotFoundCopyWithImpl(this._self, this._then);

  final NotFound _self;
  final $Res Function(NotFound) _then;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? response = freezed,}) {
  return _then(NotFound(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response?,
  ));
}


}

/// @nodoc


class MethodNotAllowed with DiagnosticableTreeMixin implements NetworkExceptions {
  const MethodNotAllowed();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.methodNotAllowed'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MethodNotAllowed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.methodNotAllowed()';
}


}




/// @nodoc


class NotAcceptable with DiagnosticableTreeMixin implements NetworkExceptions {
  const NotAcceptable();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.notAcceptable'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotAcceptable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.notAcceptable()';
}


}




/// @nodoc


class RequestTimeout with DiagnosticableTreeMixin implements NetworkExceptions {
  const RequestTimeout();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.requestTimeout'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestTimeout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.requestTimeout()';
}


}




/// @nodoc


class SendTimeout with DiagnosticableTreeMixin implements NetworkExceptions {
  const SendTimeout();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.sendTimeout'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendTimeout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.sendTimeout()';
}


}




/// @nodoc


class Conflict with DiagnosticableTreeMixin implements NetworkExceptions {
  const Conflict();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.conflict'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conflict);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.conflict()';
}


}




/// @nodoc


class InternalServerError with DiagnosticableTreeMixin implements NetworkExceptions {
  const InternalServerError();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.internalServerError'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalServerError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.internalServerError()';
}


}




/// @nodoc


class NotImplemented with DiagnosticableTreeMixin implements NetworkExceptions {
  const NotImplemented();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.notImplemented'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotImplemented);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.notImplemented()';
}


}




/// @nodoc


class ServiceUnavailable with DiagnosticableTreeMixin implements NetworkExceptions {
  const ServiceUnavailable();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.serviceUnavailable'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceUnavailable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.serviceUnavailable()';
}


}




/// @nodoc


class NoInternetConnection with DiagnosticableTreeMixin implements NetworkExceptions {
  const NoInternetConnection();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.noInternetConnection'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoInternetConnection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.noInternetConnection()';
}


}




/// @nodoc


class FormatException with DiagnosticableTreeMixin implements NetworkExceptions {
  const FormatException();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.formatException'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormatException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.formatException()';
}


}




/// @nodoc


class UnableToProcess with DiagnosticableTreeMixin implements NetworkExceptions {
  const UnableToProcess();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.unableToProcess'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnableToProcess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.unableToProcess()';
}


}




/// @nodoc


class DefaultError with DiagnosticableTreeMixin implements NetworkExceptions {
  const DefaultError(this.error);
  

 final  String error;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DefaultErrorCopyWith<DefaultError> get copyWith => _$DefaultErrorCopyWithImpl<DefaultError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.defaultError'))
    ..add(DiagnosticsProperty('error', error));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DefaultError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.defaultError(error: $error)';
}


}

/// @nodoc
abstract mixin class $DefaultErrorCopyWith<$Res> implements $NetworkExceptionsCopyWith<$Res> {
  factory $DefaultErrorCopyWith(DefaultError value, $Res Function(DefaultError) _then) = _$DefaultErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$DefaultErrorCopyWithImpl<$Res>
    implements $DefaultErrorCopyWith<$Res> {
  _$DefaultErrorCopyWithImpl(this._self, this._then);

  final DefaultError _self;
  final $Res Function(DefaultError) _then;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(DefaultError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnexpectedError with DiagnosticableTreeMixin implements NetworkExceptions {
  const UnexpectedError();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.unexpectedError'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.unexpectedError()';
}


}




/// @nodoc


class BadCertificate with DiagnosticableTreeMixin implements NetworkExceptions {
  const BadCertificate();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.badCertificate'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadCertificate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.badCertificate()';
}


}




/// @nodoc


class ConnectionError with DiagnosticableTreeMixin implements NetworkExceptions {
  const ConnectionError();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NetworkExceptions.connectionError'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NetworkExceptions.connectionError()';
}


}




// dart format on
