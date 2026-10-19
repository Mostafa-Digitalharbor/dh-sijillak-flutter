import '../../../../core/utils/result.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_deal.dart';
import '../../domain/entities/customer_invoice.dart';
import '../../domain/entities/customer_summary.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._dataSource);

  final CustomerRemoteDataSource _dataSource;

  @override
  Future<Result<List<CustomerSummary>>> getCustomers(String query) =>
      Result.guard(
        () async => [
          for (final model in await _dataSource.fetchCustomers(query))
            model.toEntity(),
        ],
      );

  @override
  Future<Result<Customer>> getCustomer(String id) => Result.guard(
    () async => (await _dataSource.fetchCustomer(id)).toEntity(),
  );

  @override
  Future<Result<List<CustomerDeal>>> getDeals(String id) => Result.guard(
    () async => [
      for (final model in await _dataSource.fetchDeals(id)) model.toEntity(),
    ],
  );

  @override
  Future<Result<List<CustomerInvoice>>> getInvoices(String id) => Result.guard(
    () async => [
      for (final model in await _dataSource.fetchInvoices(id)) model.toEntity(),
    ],
  );
}
