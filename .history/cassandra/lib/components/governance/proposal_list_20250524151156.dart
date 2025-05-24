import 'package:flutter/material.dart';
import 'governance_proposal.dart';

class ProposalList extends StatefulWidget {
  const ProposalList({Key? key}) : super(key: key);

  @override
  State<ProposalList> createState() => _ProposalListState();
}

class _ProposalListState extends State<ProposalList> {
  List<Map<String, dynamic>> _proposals = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  Future<void> _loadProposals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement proposal loading
      setState(() {
        _proposals = [
          {
            'id': '1',
            'title': 'Sample Proposal 1',
            'description': 'This is a sample proposal',
            'proposer': '0x123...',
            'requiredStake': '100',
            'yesVotes': '50',
            'noVotes': '30',
            'status': 'Active',
            'hasVoted': false,
          },
        ];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load proposals: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _vote(String proposalId, bool vote) async {
    try {
      // TODO: Implement vote logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vote recorded successfully')),
      );
      _loadProposals();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to vote: $e')),
      );
    }
  }

  Future<void> _executeProposal(String proposalId) async {
    try {
      // TODO: Implement proposal execution logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proposal executed successfully')),
      );
      _loadProposals();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to execute proposal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _proposals.length,
      itemBuilder: (context, index) {
        final proposal = _proposals[index];
        final startTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(proposal['start_time']),
        );
        final endTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(proposal['end_time']),
        );
        final isActive = proposal['status'] == 'active';
        final canExecute =
            !isActive && proposal['yes_votes'] > proposal['no_votes'];

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proposal['title'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                Text(proposal['description']),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Required Stake: ${proposal['required_stake']}'),
                    Text('Status: ${proposal['status']}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Yes: ${proposal['yes_votes']}'),
                    Text('No: ${proposal['no_votes']}'),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Voting Period: ${startTime.toString()} - ${endTime.toString()}',
                ),
                SizedBox(height: 16),
                if (isActive)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _vote(proposal['id'], true),
                        child: Text('Vote Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () => _vote(proposal['id'], false),
                        child: Text('Vote No'),
                      ),
                    ],
                  )
                else if (canExecute)
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _executeProposal(proposal['id']),
                      child: Text('Execute Proposal'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
