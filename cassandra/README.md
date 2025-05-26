# Cassandra - Decentralized Prediction Market Platform

Cassandra is a cutting-edge decentralized prediction market platform built on StarkNet. It allows users to create, participate in, and resolve predictions in a trustless and decentralized manner.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Smart Contracts](#smart-contracts)
  - [MarketFactory](#marketfactory)
  - [Market](#market)
  - [Governance](#governance)
- [Frontend](#frontend)
  - [Architecture](#architecture)
  - [Key Components](#key-components)
  - [State Management](#state-management)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the Application](#running-the-application)
- [Development](#development)
  - [Smart Contract Deployment](#smart-contract-deployment)
  - [Frontend Development](#frontend-development)
- [Testing](#testing)
- [Contributing](#contributing)

## Overview

Cassandra is a decentralized prediction market platform that enables users to:
- Create prediction markets
- Stake on outcomes
- Participate in governance
- Earn rewards
- All without requiring an upfront login

## Features

### Core Features
- No-login required prediction participation
- Secure and decentralized market creation
- Community governance system
- Real-time market updates
- Mobile-first design
- StarkNet integration

### Technical Features
- Built on StarkNet for scalability
- Zero-knowledge proofs for privacy
- Efficient market resolution
- Token-based rewards system
- Cross-chain compatibility

## Smart Contracts

### MarketFactory
- Manages market creation
- Controls market parameters
- Implements market validation
- Handles market lifecycle

### Market
- Core market contract
- Manages staking
- Handles market resolution
- Implements payout logic
- Tracks market state

### Governance
- Token-based voting
- Proposal management
- Parameter updates
- Community proposals
- Emergency functions

## Frontend

### Architecture
- Flutter framework
- Clean architecture
- Modular design
- Responsive UI
- Dark theme with neon accents

### Key Components
- `screens/`
  - `market_list_screen.dart`: Main market listing
  - `market_details_screen.dart`: Individual market view
  - `create_market_screen.dart`: Market creation
  - `governance_screen.dart`: Governance interface
  - `profile_screen.dart`: User profile

- `widgets/`
  - `feed_card.dart`: Market card component
  - `neon_splash_screen.dart`: App entry point
  - `prediction_card.dart`: Individual prediction display
  - `stake_button.dart`: Staking interface

### State Management
- Provider package for state management
- Clean separation of concerns
- Efficient data flow
- Async operations handling
- Error management

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Node.js
- StarkNet local network
- Git

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd cassandra
```

2. Install dependencies:
```bash
flutter pub get
```

3. Install smart contract dependencies:
```bash
cd contracts
npm install
```

### Running the Application

1. Start the Flutter app:
```bash
flutter run
```

2. Deploy and run smart contracts:
```bash
cd contracts
starknet-devnet
npx starknet-compile contracts/market_factory.cairo
npx starknet-deploy contracts/market_factory_compiled.json
```

## Development

### Smart Contract Deployment

1. Compile contracts:
```bash
npx starknet-compile contracts/market_factory.cairo
npx starknet-compile contracts/market.cairo
npx starknet-compile contracts/governance.cairo
```

2. Deploy contracts:
```bash
npx starknet-deploy contracts/market_factory_compiled.json
npx starknet-deploy contracts/governance_compiled.json
```

### Frontend Development

1. Run development server:
```bash
flutter run -d chrome
```

2. Hot reload:
- Save changes to see them instantly
- No need to restart the app

## Testing

### Smart Contract Tests
```bash
cd contracts
npm test
```

### Frontend Tests
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

Please ensure your code follows our style guidelines and includes appropriate tests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please contact:
- Email: support@cassandra-prediction.com
- Discord: #cassandra-prediction
- Twitter: @CassandraPred

## Acknowledgments

- Thanks to the StarkNet team for their amazing blockchain platform
- Special thanks to our community members for their valuable feedback and contributions
- Inspired by the prediction market ecosystem
