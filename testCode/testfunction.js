// The code in this file will load on every page of your site
/*
import Web3Modal from "web3modal"
import {ethers} from "ethers"
import Window from "window"
import jsdom from "jsdom"
const { JSDOM } = jsdom;
const window = new Window()
const providerOptions = {}
const web3Modal = new Web3Modal({
    network: "mainnet", // optional
    cacheProvider: true, // optional
    providerOptions, // required
});
let provider, signer

$w.onReady(function () {
	// Write your code here
	const connectButton = $w("#text67");
	connectButton.onClick( async (e) => {
		const W3provider = await web3Modal.connect()
		const ethersProvider = new ethers.providers.Web3Provider(W3provider)
		provider = ethersProvider;
		signer = await ethersProvider.getSigner()
		console.log(await signer.getChainId())
	})
});
*/

import WalletConnectProvider from "@walletconnect/web3-provider";
import { ethers } from "ethers";
import Web3Modal from "web3modal";

import React, { Component } from 'react'
import { Button } from 'react-native'

const providerOptions = {
  walletconnect: {
    package: WalletConnectProvider, // required
    options: {
      infuraId: "c6988b798b0f438080f315d27508218e" // required
    }
  }
};


const web3Modal = new Web3Modal({
	network: "mainnet", // optional
	cacheProvider: true, // optional
	providerOptions // required
  });
  
  const instance = await web3Modal.connect();
  
  const provider = new ethers.providers.Web3Provider(instance);
  const signer = provider.getSigner();
const Test = () => {
	return (
		<Button 
		onClick( async (e) => {
			const W3provider = await web3Modal.connect()
			const ethersProvider = new ethers.providers.Web3Provider(W3provider)
			provider = ethersProvider;
			signer = await ethersProvider.getSigner()
			console.log(await signer.getChainId())
		});
		/>
	)
  }

  export default Testl;
