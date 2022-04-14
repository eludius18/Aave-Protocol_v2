/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer } from "ethers";
import { Provider } from "@ethersproject/providers";

import type { ChainlinkUSDETHOracleI } from "./ChainlinkUSDETHOracleI";

export class ChainlinkUSDETHOracleIFactory {
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ChainlinkUSDETHOracleI {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as ChainlinkUSDETHOracleI;
  }
}

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "int256",
        name: "current",
        type: "int256",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "answerId",
        type: "uint256",
      },
    ],
    name: "AnswerUpdated",
    type: "event",
  },
];
