import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/order/order_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_order_item.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

class OrderListScreen extends StatefulWidget {
  static const routeName = '/order_list';

  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> with LoadingMixin, NavigationMixin, AppBarMixin {
  OrderStore? _orderStore;

  List<dynamic>? _dataCancel;

  late AuthStore _authStore;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _authStore = Provider.of<AuthStore>(context);

    RequestHelper requestHelper = Provider.of<RequestHelper>(context);

    _orderStore = OrderStore(
      requestHelper,
      customer: ConvertData.stringToInt(_authStore.user!.id),
    );
    _orderStore?.getOrders();
    if (enableCancelOrder) {
      _orderStore?.getCancelOrder();
    }
  }

  void _onScroll() {
    if (!_controller.hasClients || _orderStore!.loading || !_orderStore!.canLoadMore) return;

    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _orderStore!.getOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(builder: (_) {
      List<OrderData> orders = _orderStore!.orders;
      bool loading = _orderStore!.loading;

      bool isShimmer = orders.isEmpty && loading;
      List<OrderData> loadingOrder = List.generate(10, (index) => OrderData()).toList();

      List<OrderData> data = isShimmer ? loadingOrder : orders;
      if (_orderStore?.orderCancel != null && _orderStore?.orderCancel.isNotEmpty == true) {
        _dataCancel = _orderStore?.orderCancel;
      }

      if (_orderStore!.loadingCancel == false) {
        _orderStore!.refresh();
      }

      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('order_return')),
        body: Stack(
          children: [
            CustomScrollView(physics: const BouncingScrollPhysics(), controller: _controller, slivers: <Widget>[
              CupertinoSliverRefreshControl(
                onRefresh: _orderStore!.refresh,
                builder: buildAppRefreshIndicator,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    OrderData order = data.elementAt(index);

                    return _buildOrderList(order);
                  },
                  childCount: data.length,
                ),
              ),
              if (_orderStore!.loading)
                SliverToBoxAdapter(
                  child: buildLoading(context, isLoading: _orderStore!.canLoadMore),
                ),
            ]),
            if (_orderStore!.orders.isEmpty && !_orderStore!.loading) _buildOrderEmpty()
          ],
        ),
      );
    });
  }

  Widget _buildOrderList(OrderData order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: layoutPadding, vertical: 10),
      child: CirillaOrderItem(
        order: order,
        orderCancel: _dataCancel,
        orderStore: _orderStore,
      ),
    );
  }

  Widget _buildOrderEmpty() {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return NotificationScreen(
      title: Text(
        translate('order'),
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      content: Text(translate('order_no_order_has_been_made_yet'), style: Theme.of(context).textTheme.bodyMedium),
      iconData: FeatherIcons.box,
      textButton: Text(translate('order_return_shop')),
      onPressed: () => navigate(context, {
        "type": "tab",
        "router": "/",
        "args": {"key": "screens_category"}
      }),
    );
  }
}
