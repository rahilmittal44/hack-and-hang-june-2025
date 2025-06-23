import type { Network } from "@aptos-labs/wallet-adapter-react";

export const NETWORK: Network = (process.env.NEXT_PUBLIC_APP_NETWORK as Network) ?? "testnet";
export const APTOS_API_KEY = process.env.NEXT_PUBLIC_APTOS_API_KEY;
