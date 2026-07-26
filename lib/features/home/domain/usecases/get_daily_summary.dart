import '../repositories/home_repository.dart';

/// Usecase for getting daily summary data on the Home Screen
class GetDailySummary {
  final HomeRepository repository;

  GetDailySummary(this.repository);

  Future<void> execute() async {
    await repository.getRecentLogs();
  }
}
