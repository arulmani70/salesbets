import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:salesbets/src/common/models/models.dart';
import 'package:salesbets/src/common/utils/toast_util.dart';
import 'package:salesbets/src/home/bloc/home_bloc.dart';

class BetSlipPanel extends StatefulWidget {
  const BetSlipPanel({super.key});

  @override
  State<BetSlipPanel> createState() => _BetSlipPanelState();
}

class _BetSlipPanelState extends State<BetSlipPanel> {
  final log = Logger();
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final TextEditingController _stakeController = TextEditingController();

  @override
  void dispose() {
    _stakeController.dispose();
    selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: const Border(left: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your Bet Slip',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: ValueListenableBuilder<int>(
              valueListenable: selectedIndexNotifier,
              builder: (context, selectedIndex, _) {
                return ToggleButtons(
                  isSelected: [selectedIndex == 0, selectedIndex == 1],
                  onPressed: (int index) {
                    selectedIndexNotifier.value = index;
                  },
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: Colors.white,
                  fillColor: Colors.deepPurple,
                  borderColor: Colors.deepPurple,
                  color: Colors.deepPurple,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  constraints: const BoxConstraints(
                    minHeight: 40,
                    minWidth: 120,
                  ),
                  children: const [Text('Single Bet'), Text('Multi Bet')],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: selectedIndexNotifier,
              builder: (context, selectedIndex, _) {
                final selectedType = selectedIndex == 0 ? 'Single' : 'Multi';

                return BlocBuilder<HomePageBloc, HomePageState>(
                  builder: (context, state) {
                    final filteredBets = state.bets
                        .where((bet) => bet.type == selectedType)
                        .toList();

                    if (filteredBets.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No bets available for this type.',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredBets.length,
                      itemBuilder: (context, index) {
                        final bet = filteredBets[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stake: ₹${bet.stake}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Type: ${bet.type}'),
                                const SizedBox(height: 4),
                                const Text(
                                  'Selections:',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                ...bet.selections
                                    .map((s) => Text('• $s'))
                                    .toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Stake Per Bet'),
                    SizedBox(
                      width: 90,
                      height: 36,
                      child: TextField(
                        controller: _stakeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '\$0',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Returns: \$0.00'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      final stake = _stakeController.text.trim();
                      final type = selectedIndexNotifier.value == 0
                          ? 'Single'
                          : 'Multi';
                      final selections = ['Team A', 'Team B'];

                      if (stake.isEmpty) {
                        ToastUtil.showErrorToast(context, "Please enter stake");

                        return;
                      }

                      final bet = BetModel(
                        stake: stake,
                        type: type,
                        selections: selections,
                        id: '',
                      );

                      log.i("🟩 Placing Bet: ${bet.toJson()}");
                      context.read<HomePageBloc>().add(PlaceBet(bet));
                    },
                    child: const Text('PLACE BET'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
