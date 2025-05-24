from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.account.account import Account
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair
import asyncio
import secrets

async def create_account():
    # Generate a random private key
    private_key = secrets.randbits(251)
    print(f"Generated Private Key: 0x{private_key:064x}")
    
    # Create key pair
    key_pair = KeyPair.from_private_key(private_key)
    print(f"Public Key: 0x{key_pair.public_key:064x}")
    
    # Initialize client
    client = FullNodeClient(node_url="https://starknet-sepolia.infura.io/v3/d0715abf1c98448697d99e36f2ed2800")
    
    # Deploy account contract
    account = await Account.deploy_account(
        address=key_pair.public_key,
        class_hash=0x033434ad846cdd5f23eb73ff09fe6fddd568284a0fb7d1be20ee482f044dabe2,  # OpenZeppelin account class hash
        salt=key_pair.public_key,
        key_pair=key_pair,
        client=client,
        chain=StarknetChainId.SEPOLIA,
        constructor_calldata=[key_pair.public_key]
    )
    
    # Wait for deployment
    await account.wait_for_acceptance()
    
    print(f"\nAccount created successfully!")
    print(f"Account Address: {account.address}")
    print(f"\nSave these details securely:")
    print(f"Private Key: 0x{private_key:064x}")
    print(f"Account Address: {account.address}")
    print("\nNext steps:")
    print("1. Get test ETH from https://faucet.sepolia.starknet.io/")
    print("2. Update deploy.py with your private key and account address")
    print("3. Run deploy.py to deploy the contract")

if __name__ == "__main__":
    asyncio.run(create_account()) 