# Core Network Package

## Overview
Provides network abstractions via Dio, HTTP exception handling, error response mapping, and application API endpoint constants.

## Interface
- `[lib/core/network/remote_client.dart:RemoteClient]` - HTTP client wrapper handling `GET` requests with timeout configurations and error transformations.
- `[lib/core/network/remote_client.dart:RemoteClient.provider]` - Riverpod provider exposing the configured `RemoteClient` singleton.
- `[lib/core/network/endpoints.dart:AppEndpoints]` - Mixin containing API endpoint constants and external links (`radiosApi`, `nawawiApi`, `mailTo`, `linkPlayGoogle`).
- `[lib/core/network/exceptions/exceptions.dart:CustomException]` - Base application network exception with localized resource keys.
- `[lib/core/network/exceptions/exceptions.dart:NoConnectionException]` - Exception thrown on network connectivity failure.
- `[lib/core/network/exceptions/exceptions.dart:FetchDataException]` - Exception thrown on remote communication or server failure.
- `[lib/core/network/exceptions/handler.dart:handleDioExceptions]` - Utility mapping Dio error types (`DioExceptionType`) to typed `CustomException` subclasses.

## Invariants
- `[lib/core/network/remote_client.dart:RemoteClient]` enforces connect and receive timeouts of 7 seconds.

## Side Effects
- Outbound HTTP requests across the network.
- Console error logs emitted via `dart:developer` on request interceptor failures.

## Verification
- Run: `flutter test`
