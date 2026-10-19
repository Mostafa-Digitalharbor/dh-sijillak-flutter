import '../../../../core/error/exceptions.dart';
import '../../../../core/network/mock/mock_assets.dart';
import '../../../../core/network/mock/mock_route.dart';
import '../../domain/entities/deal_stage.dart';
import 'pipeline_endpoints.dart';
import 'pipeline_mock_store.dart';

/// Fake deals endpoints served by the mock backend. Deals created through
/// POST /deals are kept in memory and show up in later GET /deals calls.
///
/// Fixture dates are offsets from the current day, so the pipeline keeps
/// showing the same relative text ("tomorrow", "in 3 days"...) whenever the
/// app is opened.
class PipelineMockApi implements MockApiModule {
  PipelineMockApi(this._assets, {DateTime Function()? clock})
    : _store = PipelineMockStore.of(_assets, clock: clock);

  static const _defaultsAsset = 'assets/mock/pipeline/lead_defaults.json';

  /// Win probability the server assigns to a deal that starts in a stage.
  static const _stageProbability = {
    DealStage.newLead: 10,
    DealStage.qualified: 30,
    DealStage.quote: 50,
    DealStage.negotiation: 70,
    DealStage.won: 100,
  };

  final MockAssets _assets;
  final PipelineMockStore _store;

  @override
  List<MockRoute> get routes => [
    MockRoute(HttpMethod.get, PipelineEndpoints.deals, (_) => _list()),
    MockRoute(
      HttpMethod.get,
      PipelineEndpoints.leadDefaults,
      (_) => _assets.json(_defaultsAsset),
    ),
    MockRoute(HttpMethod.post, PipelineEndpoints.deals, (r) => _create(r.body)),
  ];

  Future<PipelineMockData> get _loaded => _store.data;

  Future<Object?> _list() async {
    final state = await _loaded;
    return {'stages': state.stages, 'deals': state.deals};
  }

  Future<Object?> _create(Map<String, dynamic> body) async {
    final state = await _loaded;
    final title = (body['title'] as String?)?.trim() ?? '';
    final value = (body['value'] as num?)?.toInt() ?? 0;
    final stage = DealStage.values.asNameMap()[body['stage']];
    final errors = <String, String>{
      if (title.isEmpty) 'title': 'required',
      if (value <= 0) 'value': 'invalid',
      if (stage == null) 'stage': 'invalid',
      if (!state.customers.containsKey(body['customerId']))
        'customerId': 'unknown',
      if (!state.owners.containsKey(body['ownerId'])) 'ownerId': 'unknown',
    };
    if (errors.isNotEmpty) throw ValidationException(fields: errors);

    final notes = (body['notes'] as String?)?.trim();
    final deal = <String, dynamic>{
      'id': 'd-${state.nextId++}',
      'title': title,
      'stage': stage!.name,
      'customerId': body['customerId'],
      'customerName': state.customers[body['customerId']],
      'value': value,
      'probability': _stageProbability[stage],
      'ownerId': body['ownerId'],
      'ownerName': state.owners[body['ownerId']],
      if (body['expectedClose'] != null) 'expectedClose': body['expectedClose'],
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };
    state.deals.insert(0, deal);
    _store.adjustSummary(state, stage, 1, value);
    return deal;
  }
}
