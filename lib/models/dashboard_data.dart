class StockItem {
  const StockItem({
    required this.name,
    required this.detail,
    required this.units,
  });

  final String name;
  final String detail;
  final int units;
}

class RecentSale {
  const RecentSale({
    required this.product,
    required this.customer,
    required this.time,
    required this.amount,
  });

  final String product;
  final String customer;
  final String time;
  final int amount;
}

class LiveSnapshot {
  const LiveSnapshot({
    required this.status,
    required this.when,
    required this.sales,
    required this.income,
    required this.productsSold,
  });

  final String status;
  final String when;
  final int sales;
  final int income;
  final int productsSold;
}

class DashboardData {
  const DashboardData({
    required this.income,
    required this.profit,
    required this.salesCount,
    required this.productsSold,
    required this.lowStock,
    required this.recentSales,
    required this.lastLive,
  });

  final int income;
  final int profit;
  final int salesCount;
  final int productsSold;
  final List<StockItem> lowStock;
  final List<RecentSale> recentSales;
  final LiveSnapshot lastLive;
}
