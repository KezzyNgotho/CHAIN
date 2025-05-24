from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.account.account import Account
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair
from starknet_py.contract import Contract
from starknet_py.net.client_models import Call
import asyncio
import json

# Configuration
PRIVATE_KEY = "YOUR_PRIVATE_KEY"  # Replace with your private key
ACCOUNT_ADDRESS = "YOUR_ACCOUNT_ADDRESS"  # Replace with your account address
RPC_URL = "https://starknet-goerli.infura.io/v3/d0715abf1c98448697d99e36f2ed2800"

async def deploy_contract():
    # Initialize client and account
    client = FullNodeClient(node_url=RPC_URL)
    key_pair = KeyPair.from_private_key(int(PRIVATE_KEY, 16))
    account = Account(
        address=ACCOUNT_ADDRESS,
        client=client,
        key_pair=key_pair,
        chain=StarknetChainId.GOERLI
    )

    # Read the compiled contract
    with open("target/dev/prediction_market_prediction_market.contract_class.json", "r") as f:
        contract_compiled = json.load(f)

    # Deploy the contract
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