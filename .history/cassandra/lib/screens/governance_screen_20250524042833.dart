import 'package:flutter/material.dart';
import '../components/governance/governance_proposal.dart';
import '../components/governance/proposal_list.dart';
import '../components/governance/create_proposal.dart';

class GovernanceScreen extends StatefulWidget {
  const GovernanceScreen({Key? key}) : super(key: key);

  @override
  State<GovernanceScreen> createState() => _GovernanceScreenState();
}

class _GovernanceScreenState extends State<GovernanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Governance'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateProposal(),
                ),
              );
            },
          ),
        ],
      ),
      body: ProposalList(),
    );
  }
} 