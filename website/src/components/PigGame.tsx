"use client";

import { useEffect, useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useWalletClient } from "@thalalabs/surf/hooks";
// Internal components
import { toast } from "@/components/ui/use-toast";
import { aptosClient } from "@/utils/aptosClient";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { TypeTagAddress, TypeTagU64 } from "@aptos-labs/ts-sdk";

export function PigGame() {
  const { account } = useWallet();
  const { client, connected } = useWalletClient();

  const queryClient = useQueryClient();

  const [moduleAddress, setModuleAddress] = useState<string | undefined>(
    process.env.NEXT_DEFAULT_CONTRACT_ADDRESS ?? "0x0",
  );
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const [gameTotalScore, setGameTotalScore] = useState<number>(0);
  const [gameTurnScore, setGameTurnScore] = useState<number>(0);
  const [lastRoll, setLastRoll] = useState<number>(0);
  const [round, setRound] = useState<number>(0);
  const [turn, setTurn] = useState<number>(0);

  async function rollDice() {
    if (!connected || !client) {
      return;
    }
    const committedTransaction = await client.submitTransaction({
      function: `${moduleAddress}::pig_game::roll_dice`,
      typeArguments: [],
      functionArguments: [],
    });
    const executedTransaction = await aptosClient().waitForTransaction({
      transactionHash: committedTransaction.hash,
    });
    queryClient.invalidateQueries({
      queryKey: ["pig-game-state", account?.address],
    });

    toast({
      title: "Success",
      description: `Transaction succeeded, hash: ${executedTransaction.hash}`,
    });
  }

  async function holdDice() {
    if (!connected || !client) {
      return;
    }
    const committedTransaction = await client.submitTransaction({
      function: `${moduleAddress}::pig_game::hold`,
      typeArguments: [],
      functionArguments: [],
    });
    const executedTransaction = await aptosClient().waitForTransaction({
      transactionHash: committedTransaction.hash,
    });
    queryClient.invalidateQueries({
      queryKey: ["pig-game-state", account?.address],
    });

    toast({
      title: "Success",
      description: `Transaction succeeded, hash: ${executedTransaction.hash}`,
    });
  }

  async function completeGame() {
    if (!connected || !client) {
      return;
    }
    const committedTransaction = await client.submitTransaction({
      function: `${moduleAddress}::pig_game::complete_game`,
      typeArguments: [],
      functionArguments: [],
    });
    const executedTransaction = await aptosClient().waitForTransaction({
      transactionHash: committedTransaction.hash,
    });
    queryClient.invalidateQueries({
      queryKey: ["pig-game-state", account?.address],
    });

    toast({
      title: "Success",
      description: `Transaction succeeded, hash: ${executedTransaction.hash}`,
    });
  }

  async function resetGame() {
    if (!connected || !client) {
      return;
    }
    const committedTransaction = await client.submitTransaction({
      function: `${moduleAddress}::pig_game::reset_game`,
      typeArguments: [],
      functionArguments: [],
    });
    const executedTransaction = await aptosClient().waitForTransaction({
      transactionHash: committedTransaction.hash,
    });
    queryClient.invalidateQueries({
      queryKey: ["pig-game-state", account?.address],
    });

    toast({
      title: "Success",
      description: `Transaction succeeded, hash: ${executedTransaction.hash}`,
    });
  }

  const { data } = useQuery({
    queryKey: ["pig-game-state", account?.address],
    refetchInterval: 10_000,
    queryFn: async () => {
      try {
        aptosClient()
          .view({
            payload: {
              function: `${moduleAddress}::pig_game::turn`,
              typeArguments: [],
              functionArguments: [account?.address ?? "0x0"],
              abi: {
                parameters: [new TypeTagAddress()],
                typeParameters: [],
                returnTypes: [new TypeTagU64()],
              },
            },
          })
          .then((result) => {
            setTurn(parseInt(result[0] as string));
          });
        aptosClient()
          .view({
            payload: {
              function: `${moduleAddress}::pig_game::round`,
              typeArguments: [],
              functionArguments: [account?.address ?? "0x0"],
              abi: {
                parameters: [new TypeTagAddress()],
                typeParameters: [],
                returnTypes: [new TypeTagU64()],
              },
            },
          })
          .then((result) => {
            setRound(parseInt(result[0] as string));
          });
        aptosClient()
          .view({
            payload: {
              function: `${moduleAddress}::pig_game::turn_score`,
              typeArguments: [],
              functionArguments: [account?.address ?? "0x0"],
              abi: {
                parameters: [new TypeTagAddress()],
                typeParameters: [],
                returnTypes: [new TypeTagU64()],
              },
            },
          })
          .then((result) => {
            setGameTurnScore(parseInt(result[0] as string));
          });
        aptosClient()
          .view({
            payload: {
              function: `${moduleAddress}::pig_game::total_score`,
              typeArguments: [],
              functionArguments: [account?.address ?? "0x0"],
              abi: {
                parameters: [new TypeTagAddress()],
                typeParameters: [],
                returnTypes: [new TypeTagU64()],
              },
            },
          })
          .then((result) => {
            setGameTotalScore(parseInt(result[0] as string));
          });
        aptosClient()
          .view({
            payload: {
              function: `${moduleAddress}::pig_game::last_roll`,
              typeArguments: [],
              functionArguments: [account?.address ?? "0x0"],
              abi: {
                parameters: [new TypeTagAddress()],
                typeParameters: [],
                returnTypes: [new TypeTagU64()],
              },
            },
          })
          .then((result) => {
            setLastRoll(parseInt(result[0] as string));
          });

        return {};
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
      } catch (error: any) {
        toast({
          variant: "destructive",
          title: "Error",
          description: error,
        });
        return {};
      }
    },
  });

  useEffect(() => {
    if (data) {
    }
  }, [data]);

  return (
    <div className="flex flex-col gap-6">
      Game Address:{" "}
      <Input disabled={!client} placeholder="Game Address" onChange={(e) => setModuleAddress(e.target.value)} />
      <h4 className="text-lg font-medium">Game State:</h4>
      <h5 className="text-lg font-medium">Roll: {lastRoll}</h5>
      <h5 className="text-lg font-medium">Round: {round}</h5>
      <h5 className="text-lg font-medium">Turn: {turn}</h5>
      <h5 className="text-lg font-medium">Turn Score: {gameTurnScore}</h5>
      <h5 className="text-lg font-medium">Total Score: {gameTotalScore}</h5>
      <Button disabled={!client} onClick={rollDice}>
        Roll
      </Button>
      <Button disabled={!client} onClick={holdDice}>
        Hold
      </Button>
      <Button disabled={!client} onClick={completeGame}>
        Complete Game
      </Button>
      <Button disabled={!client} onClick={resetGame}>
        Reset Game
      </Button>
    </div>
  );
}
