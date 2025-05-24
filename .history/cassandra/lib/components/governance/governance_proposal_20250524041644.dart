import 'package:flutter/material.dart';
import 'package:starknet/starknet.dart';
import '../../services/starknet_service.dart';

class GovernanceProposal extends StatefulWidget {
  final String proposalId;
  final String title;
  final String description;
  final String proposer;
  final String requiredStake;
  final String yesVotes;
  final String noVotes;
  final String status;
  final bool hasVoted;
  final bool? userVote;

  const GovernanceProposal({
    Key? key,
    required this.proposalId,
    required this.title,
    required this.description,
    required this.proposer,
    required this.requiredStake,
    required this.yesVotes,
    required this.noVotes,
    required this.status,
    required this.hasVoted,
    this.userVote,
  }) : super(key: key);

  @override
  State<GovernanceProposal> createState() => _GovernanceProposalState();
}

class _GovernanceProposalState extends State<GovernanceProposal> {
  final StarkNetService _starknetService = StarkNetService();
  bool _isVoting = false;

  Future<void> _vote(bool vote) async {
    if (_isVoting) return;

    setState(() {
      _isVoting = true;
    });

    try {
      await _starknetService.voteOnStakingProposal(
        widget.proposalId,
        vote,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vote cast successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cast vote: $e')),
      );
    } finally {
      setState(() {
        _isVoting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Proposer: ${widget.proposer}'),
                Text('Required Stake: ${widget.requiredStake}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Yes Votes: ${widget.yesVotes}'),
                Text('No Votes: ${widget.noVotes}'),
              ],
            ),
            SizedBox(height: 8),
            Text('Status: ${widget.status}'),
            if (!widget.hasVoted && widget.status == 'Active')
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _isVoting ? null : () => _vote(true),
                      child: Text('Vote Yes'),
                    ),
                    ElevatedButton(
                      onPressed: _isVoting ? null : () => _vote(false),
                      child: Text('Vote No'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
} 