#[starknet::interface]
trait IEvmFactsRegistry<TContractState> {
    fn get_storage_uint(
        self: TContractState,
        block: felt252,
        account_160: felt252,
        slot: StorageSlot,
        proof_sizes_bytes: Array<felt252>,
        proof_sizes_words: Array<felt252>,
        proofs_concat: Array<felt252>
    ) -> u256;
}


#[starknet::contract]
mod ethstark_handler {
    use starknet::eth_signature::verify_eth_signature;
    use starknet::secp256_trait::{Secp256k1Point, Signature, recover_public_key};

    #[external(v0)]
    impl EthStarkHandler of EthStarkHandlerTrait {
        fn claim(
            ref self: ContractState,
            block: felt252,
            account_160: felt252,
            slot: StorageSlot,
            proof_sizes_bytes: Array<felt252>,
            proof_sizes_words: Array<felt252>,
            proofs_concat: Array<felt252>,
            signature: Signature,
            msg_hash: felt252

            

        ) {
            let ens_owner_address = IEvmFactsRegistryDispatcher {
                contract_address: contract_address_const::<HERODOTUS_FACTS_REGISTRY>(),
            }
                .get_storage_uint(
                    block: block,
                    account_160: account_160,
                    slot: slot,
                    proof_sizes_bytes: proof_sizes_bytes,
                    proof_sizes_words: proof_sizes_words,
                    proofs_concat: proofs_concat
                );

            // ECDSA signature verification
            verify_eth_signature(msg_hash, signature, ens_owner_address)

            // ECDSA signature public key recovery
            let public_key = recover_public_key::<Secp256k1Point>(msg_hash, signature).unwrap();
            
            // TODO: Call StarkID resolver to mint/transfer [handle]eth.stark
            
        }


    }


}
