import asyncio
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.account.account import Account
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair

# Configuration
PRIVATE_KEY = "YOUR_PRIVATE_KEY"  # Replace with your private key
ACCOUNT_ADDRESS = "YOUR_ACCOUNT_ADDRESS"  # Replace with your account address
RPC_URL = "https://starknet-goerli.infura.io/v3/d0715abf1c98448697d99e36f2ed2800"

async def check_balance():
    # Initialize client and account
    client = FullNodeClient(node_url=RPC_URL)
    key_pair = KeyPair.from_private_key(int(PRIVATE_KEY, 16))
    account = Account(
        address=ACCOUNT_ADDRESS,
        client=client,
        key_pair=key_pair,
        chain=StarknetChainId.GOERLI
    )

    # Get balance
    balance = await account.get_balance()
    print(f"\nAccount Balance: {balance / 1e18} ETH")
    print(f"Account Address: {account.address}")

if __name__ == "__main__":
    asyncio.run(check_balance()) 