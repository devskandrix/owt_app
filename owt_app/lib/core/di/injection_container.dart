import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/chat/data/datasources/zego_token_remote_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/data/repositories/zego_token_repository_impl.dart';
import '../../features/chat/domain/repositories/zego_token_repository.dart';
import '../../features/chat/domain/usecases/get_zego_token.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/send_signup_otp.dart';
import '../../features/auth/domain/usecases/social_sign_in.dart';
import '../../features/auth/domain/usecases/verify_signup_otp.dart';
import '../../features/add_photos/data/datasources/photos_remote_data_source.dart';
import '../../features/add_photos/data/repositories/photos_repository_impl.dart';
import '../../features/add_photos/domain/repositories/photos_repository.dart';
import '../../features/add_photos/domain/usecases/delete_photo.dart';
import '../../features/add_photos/domain/usecases/get_my_photos.dart';
import '../../features/add_photos/domain/usecases/upload_photo.dart';
import '../../features/add_photos/presentation/cubit/add_photos_cubit.dart';
import '../../features/create_account/presentation/cubit/create_account_cubit.dart';
import '../../features/dashboard/data/datasources/clubs_remote_data_source.dart';
import '../../features/dashboard/data/repositories/clubs_repository_impl.dart';
import '../../features/dashboard/domain/repositories/clubs_repository.dart';
import '../../features/dashboard/domain/usecases/get_home_clubs.dart';
import '../../features/dashboard/domain/usecases/get_trending_clubs.dart';
import '../../features/dashboard/domain/usecases/search_clubs.dart';
import '../../features/dashboard/domain/usecases/save_search_history.dart';
import '../../features/dashboard/domain/usecases/get_search_history.dart';
import '../../features/dashboard/domain/usecases/delete_search_history.dart';
import '../../features/dashboard/domain/usecases/clear_search_history.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/friends/data/repositories/friends_repository_impl.dart';
import '../../features/friends/domain/repositories/friends_repository.dart';
import '../../features/friends/domain/usecases/get_friend_profile.dart';
import '../../features/friends/domain/usecases/get_friends.dart';
import '../../features/friends/presentation/cubit/friends_cubit.dart';
import '../../features/interests/data/datasources/interests_remote_data_source.dart';
import '../../features/interests/data/repositories/interests_repository_impl.dart';
import '../../features/interests/domain/repositories/interests_repository.dart';
import '../../features/interests/domain/usecases/get_interests.dart';
import '../../features/interests/domain/usecases/update_selected_interests.dart';
import '../../features/interests/presentation/cubit/interests_cubit.dart';
import '../../features/matchmaking/data/datasources/matchmaking_remote_data_source.dart';
import '../../features/matchmaking/data/repositories/matchmaking_repository_impl.dart';
import '../../features/matchmaking/domain/repositories/matchmaking_repository.dart';
import '../../features/likes/presentation/cubit/likes_cubit.dart';
import '../../features/matchmaking/domain/usecases/accept_like.dart';
import '../../features/matchmaking/domain/usecases/block_user.dart';
import '../../features/matchmaking/domain/usecases/check_in_going_tonight.dart';
import '../../features/matchmaking/domain/usecases/decline_like.dart';
import '../../features/matchmaking/domain/usecases/discover_profiles.dart';
import '../../features/matchmaking/domain/usecases/get_active_going_tonight_badges.dart';
import '../../features/matchmaking/domain/usecases/get_received_likes.dart';
import '../../features/matchmaking/domain/usecases/join_match_queue.dart';
import '../../features/matchmaking/domain/usecases/like_profile.dart';
import '../../features/matchmaking/domain/usecases/pass_profile.dart';
import '../../features/phone_number/presentation/cubit/send_otp_cubit.dart';
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_notifications.dart';
import '../../features/notifications/domain/usecases/get_unread_notification_count.dart';
import '../../features/notifications/domain/usecases/mark_notification_read.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/notifications/presentation/cubit/unread_notifications_cubit.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_my_profile.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/splash/presentation/cubit/google_sign_in_cubit.dart';
import '../../features/verification/presentation/cubit/verify_otp_cubit.dart';
import '../../features/todo/data/datasources/todo_local_data_source.dart';
import '../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../features/todo/domain/repositories/todo_repository.dart';
import '../../features/todo/domain/usecases/add_todo.dart';
import '../../features/todo/domain/usecases/get_todos.dart';
import '../../features/todo/domain/usecases/toggle_todo.dart';
import '../../features/todo/presentation/cubit/todo_cubit.dart';
import '../network/dio_client.dart';
import '../services/location_service.dart';

final sl = GetIt.instance;

/// Registers every dependency for the app. Call once in `main()` before
/// `runApp`. Cubits are registered as factories (a fresh instance per
/// screen); data sources and repositories are singletons.
///
/// [onSessionExpired] is invoked by the shared [Dio] instance whenever a
/// 401 can't be resolved by refreshing the session (see [DioClient]) — the
/// caller should clear any local session state and send the user back to
/// sign in.
Future<void> initDependencies({
  required Future<void> Function() onSessionExpired,
}) async {
  // Core - Network
  sl.registerLazySingleton<Dio>(
    () => DioClient.create(onSessionExpired: onSessionExpired),
  );

  // Features - Auth
  sl.registerFactory(() => GoogleSignInCubit(sl()));
  sl.registerFactory(() => SendOtpCubit(sl()));
  sl.registerFactory(() => VerifyOtpCubit(sl()));
  sl.registerFactory(() => CreateAccountCubit(sl()));

  sl.registerLazySingleton(() => SocialSignIn(sl()));
  sl.registerLazySingleton(() => SendSignupOtp(sl()));
  sl.registerLazySingleton(() => VerifySignupOtp(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );

  // Features - Interests
  sl.registerFactory(() => InterestsCubit(sl(), sl()));

  sl.registerLazySingleton(() => GetInterests(sl()));
  sl.registerLazySingleton(() => UpdateSelectedInterests(sl()));

  sl.registerLazySingleton<InterestsRepository>(
    () => InterestsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<InterestsRemoteDataSource>(
    () => InterestsRemoteDataSource(sl()),
  );

  // Features - Dashboard
  sl.registerFactory(() => DashboardCubit(sl(), sl(), sl()));

  sl.registerLazySingleton(() => GetHomeClubs(sl()));
  sl.registerLazySingleton(() => GetTrendingClubs(sl()));
  sl.registerLazySingleton(() => SearchClubs(sl()));
  sl.registerLazySingleton(() => SaveSearchHistory(sl()));
  sl.registerLazySingleton(() => GetSearchHistory(sl()));
  sl.registerLazySingleton(() => DeleteSearchHistory(sl()));
  sl.registerLazySingleton(() => ClearSearchHistory(sl()));
  sl.registerFactory(() => SearchCubit(sl(), sl(), sl(), sl(), sl()));

  sl.registerLazySingleton<ClubsRepository>(() => ClubsRepositoryImpl(sl()));

  sl.registerLazySingleton<ClubsRemoteDataSource>(
    () => ClubsRemoteDataSource(sl()),
  );

  sl.registerLazySingleton(() => const LocationService());

  // Features - Matchmaking (Going Tonight + swipe queue)
  sl.registerLazySingleton(() => CheckInGoingTonight(sl()));
  sl.registerLazySingleton(() => GetActiveGoingTonightBadges(sl()));
  sl.registerLazySingleton(() => DiscoverProfiles(sl()));
  sl.registerLazySingleton(() => LikeProfile(sl()));
  sl.registerLazySingleton(() => PassProfile(sl()));
  sl.registerLazySingleton(() => JoinMatchQueue(sl()));
  sl.registerLazySingleton(() => GetReceivedLikes(sl()));
  sl.registerLazySingleton(() => AcceptLike(sl()));
  sl.registerLazySingleton(() => DeclineLike(sl()));
  sl.registerLazySingleton(() => BlockUser(sl()));

  // Features - Likes
  sl.registerFactory(() => LikesCubit(sl(), sl(), sl()));

  sl.registerLazySingleton<MatchmakingRepository>(
    () => MatchmakingRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<MatchmakingRemoteDataSource>(
    () => MatchmakingRemoteDataSource(sl()),
  );

  // Features - Profile
  // One shared instance: the bottom nav shows its primary photo too.
  sl.registerLazySingleton(() => ProfileCubit(sl()));

  sl.registerLazySingleton(() => GetMyProfile(sl()));

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl()),
  );

  // Features - Chat (ZEGOCLOUD token for live mode)
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => GetZegoToken(sl()));
  sl.registerLazySingleton<ZegoTokenRepository>(
    () => ZegoTokenRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ZegoTokenRemoteDataSource>(
    () => ZegoTokenRemoteDataSource(sl()),
  );

  // Features - Notifications
  // One shared count: every bell shows the same badge.
  sl.registerLazySingleton(() => UnreadNotificationsCubit(sl()));
  sl.registerFactory(() => NotificationsCubit(sl(), sl(), sl()));

  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerLazySingleton(() => GetUnreadNotificationCount(sl()));
  sl.registerLazySingleton(() => MarkNotificationRead(sl()));

  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSource(sl()),
  );

  // Features - Friends (matches)
  sl.registerFactory(() => FriendsCubit(sl()));

  sl.registerLazySingleton(() => GetFriends(sl()));
  sl.registerLazySingleton(() => GetFriendProfile(sl()));

  sl.registerLazySingleton<FriendsRepository>(
    () => FriendsRepositoryImpl(sl()),
  );

  // Features - Add Photos
  sl.registerFactory(() => AddPhotosCubit(sl(), sl(), sl()));

  sl.registerLazySingleton(() => GetMyPhotos(sl()));
  sl.registerLazySingleton(() => UploadPhoto(sl()));
  sl.registerLazySingleton(() => DeletePhoto(sl()));

  sl.registerLazySingleton<PhotosRepository>(
    () => PhotosRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<PhotosRemoteDataSource>(
    () => PhotosRemoteDataSource(sl()),
  );

  // Features - Todo
  sl.registerFactory(
    () => TodoCubit(getTodos: sl(), addTodo: sl(), toggleTodo: sl()),
  );

  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => AddTodo(sl()));
  sl.registerLazySingleton(() => ToggleTodo(sl()));

  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));

  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(),
  );
}
