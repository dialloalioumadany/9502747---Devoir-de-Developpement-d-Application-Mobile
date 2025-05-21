import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'home.dart';

class DashboardPage extends StatelessWidget {
  final List<Expense> expenses;
  const DashboardPage({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    Map<String, double> totalByCategory = {};
    for (var expense in expenses) {
      totalByCategory[expense.category] =
          (totalByCategory[expense.category] ?? 0) + expense.amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF3F5FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre total de dépenses : ${expenses.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Répartition des dépenses par catégorie :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (totalByCategory.isNotEmpty)
              PieChart(
                dataMap: totalByCategory,
                chartRadius: 160,
                legendOptions: const LegendOptions(
                  legendPosition: LegendPosition.right,
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                  showChartValues: true,
                ),
              )
            else
              const Text('Aucune dépense à afficher.'),
            const SizedBox(height: 24),
            const Text(
              'Total par catégorie :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...totalByCategory.entries.map(
              (entry) => ListTile(
                title: Text(entry.key),
                trailing: Text('${entry.value.toStringAsFixed(2)} FCFA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
