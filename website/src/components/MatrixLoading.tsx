"use client";

import { useEffect, useState } from "react";

export function MatrixLoading() {
  const [dots, setDots] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setDots((prev) => (prev + 1) % 4);
    }, 500);

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="flex items-center justify-center space-x-1">
      <div className="matrix-text text-lg font-mono">LOADING{".".repeat(dots)}</div>
    </div>
  );
}
