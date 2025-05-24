from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.account.account import Account
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair
from starknet_py.contract import Contract
import asyncio

# Replace these with your account details after creating an account
PRIVATE_KEY = "0x..."  # Your private key
ACCOUNT_ADDRESS = "0x..."  # Your account address

async def deploy_contract():
    # Initialize client
    client = FullNodeClient(node_url="https://starknet-sepolia.infura.io/v3/d0715abf1c98448697d99e36f2ed2800")
    
    # Create account
    key_pair = KeyPair.from_private_key(int(PRIVATE_KEY, 16))
    account = Account(
        address=ACCOUNT_ADDRESS,
        client=client,
        key_pair=key_pair,
        chain=StarknetChainId.SEPOLIA
    )
    
    # Deploy contract
    print("Deploying contract...")
    deployment = await Contract.deploy(
        account=account,
        compiled_contract="target/dev/prediction_market_PredictionMarket.contract_class.json",
        constructor_args=[]
    )
    
    # Wait for deployment
    await deployment.wait_for_acceptance()
    
    print(f"\nContract deployed successfully!")
    print(f"Contract Address: {deployment.deployed_contract.address}")
    print("\nSave this address for future interactions with the contract.")

if __name__ == "__main__":
    asyncio.run(deploy_contract()) 