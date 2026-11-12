class ApiEndpoints {
  static const String batches = '/api/batches';
  static String batchAction(int batchId) => '/api/batches/$batchId/action';
  static const String dashboard = '/api/dashboard';
  static const String lossesReport = '/api/reports/losses';
  static const String demoSeed = '/api/demo/seed';
}
