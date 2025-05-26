import asyncio
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.account.account import Account
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair
from starknet_py.contract import Contract
from starknet_py.net.client_errors import ClientError

# Configuration
PRIVATE_KEY = "0x31ce32eb0348289215be1b2cfbe5e3b5b42ce27eb49e204e2336a536033b668"
ACCOUNT_ADDRESS = "0x2195d4d849cddeaaad7e62d7aaf49ee7cc79534d41c6271eed7535c9cb6cce1"
CONTRACT_ADDRESS = "0x0245dfbee17aec37573fe5d3c8b9160eba3ba8b44a29366fbcee838be8cca192"
RPC_URL = "https://starknet-sepolia.public.blastapi.io"

async def test_prediction_market():
    try:
        # Initialize client and account
        print("Initializing client and account...")
        client = FullNodeClient(node_url=RPC_URL)
        key_pair = KeyPair.from_private_key(int(PRIVATE_KEY, 16))
        account = Account(
            address=ACCOUNT_ADDRESS,
            client=client,
            key_pair=key_pair,
            chain=StarknetChainId.SEPOLIA
        )

        # Create contract instance
        print("Creating contract instance...")
        contract = await Contract.from_address(
            address=CONTRACT_ADDRESS,
            provider=account
        )

        # Print available functions
        print("\nAvailable functions:")
        for func in contract.functions:
            print(f"- {func}")

        # Test creating a market
        print("\nCreating a new market...")
        question = "Will ETH price reach $5000 by end of 2024?"
        category = "crypto"
        end_time = 1735689600  # Dec 31, 2024
        
        try:
            # Create market using contract function
            tx = await contract.functions["create_market"].invoke(
                question=question,
                category=category,
                end_time=end_time,
                max_fee=100000000000000  # 0.0001 ETH
            )
            print("Transaction sent! Waiting for acceptance...")
            await tx.wait_for_acceptance()
            print("Market created successfully!")
            print(f"Transaction hash: {hex(tx.transaction_hash)}")
        except Exception as e:
            print(f"Error creating market: {str(e)}")

        # Test getting market details
        print("\nGetting market details...")
        try:
            result = await contract.functions["get_market_details"].call(market_id=0)
            print(f"Market details: {result}")
        except Exception as e:
            print(f"Error getting market details: {str(e)}")

        # Test placing a bet
        print("\nPlacing a bet...")
        try:
            # Place bet using contract function
            tx = await contract.functions["place_bet"].invoke(
                market_id=0,
                amount=1000000000000000000,  # 1 ETH
                is_yes=1,
                max_fee=100000000000000  # 0.0001 ETH
            )
            print("Bet transaction sent! Waiting for acceptance...")
            await tx.wait_for_acceptance()
            print("Bet placed successfully!")
            print(f"Transaction hash: {hex(tx.transaction_hash)}")
        except Exception as e:
            print(f"Error placing bet: {str(e)}")

    except ClientError as e:
        print(f"Network error: {str(e)}")
        print("Please check your internet connection and RPC endpoint.")
    except Exception as e:
        print(f"Unexpected error: {str(e)}")

if __name__ == "__main__":
    asyncio.run(test_prediction_market()) 