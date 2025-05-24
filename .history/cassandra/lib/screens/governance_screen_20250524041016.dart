import 'package:flutter/material.dart';
import 'package:cassandra/services/mock_data_service.dart';
import 'package:cassandra/models/proposal.dart';
import 'package:intl/intl.dart';

class GovernanceScreen extends StatelessWidget {
  const GovernanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proposals = MockDataService.getProposals();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Governance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProposalList(proposals),
            const SizedBox(height: 16),
            _buildNewProposalButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalList(List<Proposal> proposals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Proposals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...proposals.map((proposal) => _buildProposalCard(proposal)),
      ],
    );
  }

  Widget _buildProposalCard(Proposal proposal) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    proposal.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildProposalStatus(proposal),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Proposed by ${proposal.proposer.username}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(proposal.description),
            const SizedBox(height: 16),
            _buildProposalInfo('Start Date', dateFormat.format(proposal.startTime)),
            _buildProposalInfo('End Date', dateFormat.format(proposal.endTime)),
            _buildProposalInfo('Required Stake', '${proposal.requiredStake} tokens'),
            const SizedBox(height: 16),
            _buildVotingProgress(proposal),
            const SizedBox(height: 16),
            if (proposal.isActive)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement vote yes
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Vote Yes'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement vote no
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Vote No'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalStatus(Proposal proposal) {
    Color color;
    String text;

    switch (proposal.status) {
      case 0:
        color = Colors.blue;
        text = 'Active';
        break;
      case 1:
        color = Colors.green;
        text = 'Passed';
        break;
      case 2:
        color = Colors.red;
        text = 'Failed';
        break;
      case 3:
        color = Colors.purple;
        text = 'Executed';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildProposalInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildVotingProgress(Proposal proposal) {
    final totalVotes = proposal.yesVotes + proposal.noVotes;
    final yesPercentage = proposal.yesPercentage;
    final noPercentage = proposal.noPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Yes: ${proposal.yesVotes} tokens'),
            Text('No: ${proposal.noVotes} tokens'),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: yesPercentage / 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Yes: ${yesPercentage.toStringAsFixed(1)}% | No: ${noPercentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNewProposalButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement new proposal form
      },
      child: const Text('Create New Proposal'),
    );
  }
} 