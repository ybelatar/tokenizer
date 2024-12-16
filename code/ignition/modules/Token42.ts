// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SUPPLY = 10 ** 7;

const Token42Module = buildModule("TokenModule", (m) => {
  const supply = m.getParameter("lockedAmount", SUPPLY);

  const token42 = m.contract("Token42", [supply]);

  return { token42 };
});

export default Token42Module;
