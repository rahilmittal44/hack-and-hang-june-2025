"use client";

import { Header } from "@/components/Header";
import { PigGame } from "@/components/PigGame";
// Internal Components
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { useWallet } from "@aptos-labs/wallet-adapter-react";

function App() {
  const { connected } = useWallet();

  return (
    <>
      <Header />
      <div className="flex items-center justify-center flex-col">
        {connected ? (
          <Card>
            <CardContent className="flex flex-col gap-10 pt-6">
              <PigGame />
            </CardContent>
          </Card>
        ) : (
          <CardHeader>
            <CardTitle>To get started Connect your wallet in the upper right</CardTitle>
          </CardHeader>
        )}
      </div>
    </>
  );
}

export default App;
