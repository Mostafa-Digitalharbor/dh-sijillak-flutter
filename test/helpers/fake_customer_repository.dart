import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/features/customer/domain/entities/customer.dart';
import 'package:sijilak/features/customer/domain/entities/customer_deal.dart';
import 'package:sijilak/features/customer/domain/entities/customer_invoice.dart';
import 'package:sijilak/features/customer/domain/entities/customer_summary.dart';
import 'package:sijilak/features/customer/domain/entities/new_customer.dart';
import 'package:sijilak/features/customer/domain/repositories/customer_repository.dart';

/// A customer profile with only the identity fields filled in.
Customer fakeCustomer({
  String id = 'c-1',
  String name = 'Acme',
  String location = 'Riyadh',
}) => Customer(
  id: id,
  name: name,
  location: location,
  city: '',
  sector: '',
  phone: '',
  email: '',
  address: '',
  commercialRegistration: '',
  vatNumber: '',
  customerSince: DateTime(2024),
  accountOwner: '',
  totalSales: 0,
  amountDue: 0,
  openDeals: 0,
  activity: const [],
);

/// Hand-written customer repository: answers from the lists it is given, or
/// with [failure] when set. Records what was asked.
class FakeCustomerRepository implements CustomerRepository {
  FakeCustomerRepository({
    this.customers = const [],
    this.deals = const [],
    this.failure,
  });

  final List<CustomerSummary> customers;
  final List<CustomerDeal> deals;
  final Failure? failure;

  final queries = <String>[];
  final dealRequests = <String>[];
  final created = <NewCustomer>[];

  Result<T> _answer<T>(T value) =>
      failure == null ? Success(value) : Failed(failure!);

  @override
  Future<Result<List<CustomerSummary>>> getCustomers(String query) async {
    queries.add(query);
    return _answer([
      for (final customer in customers)
        if (query.isEmpty || customer.name.contains(query)) customer,
    ]);
  }

  @override
  Future<Result<Customer>> getCustomer(String id) async {
    final match = customers.where((c) => c.id == id).firstOrNull;
    if (failure != null) return Failed(failure!);
    if (match == null) return const Failed(NotFoundFailure());
    return Success(
      fakeCustomer(id: match.id, name: match.name, location: match.location),
    );
  }

  @override
  Future<Result<Customer>> createCustomer(NewCustomer customer) async {
    created.add(customer);
    return _answer(fakeCustomer(id: 'c-new', name: customer.name));
  }

  @override
  Future<Result<List<CustomerDeal>>> getDeals(String id) async {
    dealRequests.add(id);
    return _answer(deals);
  }

  @override
  Future<Result<List<CustomerInvoice>>> getInvoices(String id) async =>
      _answer(const <CustomerInvoice>[]);
}
