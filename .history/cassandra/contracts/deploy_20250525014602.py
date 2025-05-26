import asyncio
import json
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.account.account import Account
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair
from starknet_py.contract import Contract

# Configuration
PRIVATE_KEY = "0x31ce32eb0348289215be1b2cfbe5e3b5b42ce27eb49e204e2336a536033b668"
ACCOUNT_ADDRESS = "0x2195d4d849cddeaaad7e62d7aaf49ee7cc79534d41c6271eed7535c9cb6cce1"
RPC_URL = "https://starknet-sepolia.infura.io/v3/d0715abf1c98448697d99e36f2ed2800"

async def deploy_contract():
    # Initialize client and account
    client = FullNodeClient(node_url=RPC_URL)
    key_pair = KeyPair.from_private_key(int(PRIVATE_KEY, 16))
    account = Account(
        address=ACCOUNT_ADDRESS,
        client=client,
        key_pair=key_pair,
        chain=StarknetChainId.SEPOLIA
    )

    # Read the compiled contract
    compiled_contract_path = "target/dev/PredictionMarket.contract_class.json"
    try:
        with open(compiled_contract_path, "r") as f:
            contract_compiled = json.load(f)
    except FileNotFoundError:
        print(f"Error: Compiled contract file not found at {compiled_contract_path}. Please compile the contract first.")
        return

    # Deploy the contract
    print("Deploying contract...")
    deploy_result = await Contract.deploy_contract(
        account=account,
        compiled_contract=contract_compiled,
        constructor_args=[],
    )
    
    # Wait for the transaction to be accepted
    await deploy_result.wait_for_acceptance()
    
    print(f"Contract deployed at: {deploy_result.deployed_contract.address}")

if __name__ == "__main__":
    asyncio.run(deploy_contract()) 