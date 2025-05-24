use starknet::ContractAddress;
use starknet::get_caller_address;

#[starknet::interface]
trait IOracle<TContractState> {
    fn submit_data(ref self: TContractState, market_id: u32, data: felt252);
    fn get_data(self: @TContractState, market_id: u32) -> OracleData;
}

#[derive(Drop, starknet::Store)]
struct OracleData {
    data: felt252,
    timestamp: u64,
    submitter: ContractAddress,
}

#[starknet::contract]
mod Oracle {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;

    #[storage]
    struct Storage {
        oracle_data: StorageMap::<u32, OracleData>,
        authorized_submitters: StorageMap::<ContractAddress, bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        DataSubmitted: DataSubmitted,
        SubmitterAuthorized: SubmitterAuthorized,
    }

    #[derive(Drop, starknet::Event)]
    struct DataSubmitted {
        market_id: u32,
        data: felt252,
        submitter: ContractAddress,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct SubmitterAuthorized {
        submitter: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Authorize the contract deployer
        let deployer = get_caller_address();
        self.authorized_submitters.write(deployer, true);
    }

    #[abi(embed_v0)]
    impl OracleImpl of super::IOracle<ContractState> {
        fn submit_data(ref self: ContractState, market_id: u32, data: felt252) {
            let caller = get_caller_address();
            assert(self.authorized_submitters.read(caller), 'Not authorized');

            let oracle_data = OracleData {
                data,
                timestamp: get_block_timestamp(),
                submitter: caller,
            };

            self.oracle_data.write(market_id, oracle_data);

            self.emit(DataSubmitted {
                market_id,
                data,
                submitter: caller,
                timestamp: get_block_timestamp(),
            });
        }

        fn get_data(self: @ContractState, market_id: u32) -> OracleData {
            self.oracle_data.read(market_id)
        }
    }

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn authorize_submitter(ref self: ContractState, submitter: ContractAddress) {
            let caller = get_caller_address();
            assert(self.authorized_submitters.read(caller), 'Not authorized');
            self.authorized_submitters.write(submitter, true);
            self.emit(SubmitterAuthorized { submitter });
        }
    }
} 