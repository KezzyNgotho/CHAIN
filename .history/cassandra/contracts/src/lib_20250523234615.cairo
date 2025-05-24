#[starknet::interface]
trait IPredictionMarket {
    fn create_market(self: @ContractState, question: felt252, end_time: u64) -> u32;
    fn place_bet(self: @ContractState, market_id: u32, outcome: bool, amount: u256);
    fn resolve_market(self: @ContractState, market_id: u32, outcome: bool);
    fn get_market_details(self: @ContractState, market_id: u32) -> (felt252, u64, bool, u256, u256);
}

#[starknet::contract]
mod PredictionMarket {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use zeroable::Zeroable;
    use array::ArrayTrait;
    use box::BoxTrait;
    use option::OptionTrait;
    use traits::TryInto;
    use integer::{u256_from_felt252, U256TryIntoFelt252};

    #[storage]
    struct Storage {
        markets: LegacyMap::<u32, Market>,
        next_market_id: u32,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Market {
        question: felt252,
        end_time: u64,
        resolved: bool,
        outcome: bool,
        yes_amount: u256,
        no_amount: u256,
    }

    #[external(v0)]
    impl PredictionMarketImpl of super::IPredictionMarket {
        fn create_market(self: @ContractState, question: felt252, end_time: u64) -> u32 {
            let market_id = self.next_market_id.read();
            self.next_market_id.write(market_id + 1);

            let market = Market {
                question,
                end_time,
                resolved: false,
                outcome: false,
                yes_amount: 0,
                no_amount: 0,
            };

            self.markets.write(market_id, market);
            market_id
        }

        fn place_bet(self: @ContractState, market_id: u32, outcome: bool, amount: u256) {
            let mut market = self.markets.read(market_id);
            assert(!market.resolved, 'Market already resolved');
            assert(block_timestamp::get_block_timestamp() < market.end_time, 'Market ended');

            if outcome {
                market.yes_amount += amount;
            } else {
                market.no_amount += amount;
            }

            self.markets.write(market_id, market);
        }

        fn resolve_market(self: @ContractState, market_id: u32, outcome: bool) {
            let mut market = self.markets.read(market_id);
            assert(!market.resolved, 'Market already resolved');
            assert(block_timestamp::get_block_timestamp() >= market.end_time, 'Market not ended');

            market.resolved = true;
            market.outcome = outcome;
            self.markets.write(market_id, market);
        }

        fn get_market_details(self: @ContractState, market_id: u32) -> (felt252, u64, bool, u256, u256) {
            let market = self.markets.read(market_id);
            (market.question, market.end_time, market.resolved, market.yes_amount, market.no_amount)
        }
    }
}