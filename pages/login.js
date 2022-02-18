import { ethers } from 'ethers'
import Web3Modal from "web3modal"
import Web3 from 'web3'
import { useEffect, useState } from 'react'
import Head from 'next/head'
import { result } from 'lodash'
import { Moralis } from 'moralis'

export default function userManage() {
    //////////////////////////////////////////////////////////////////////
    const appId = "vdgEX5APUMifU8c5dhB5F8Xm3bb8X5uGEa0LZRxf";
    const serverUrl = "https://6na6pzj82wfu.usemoralis.com:2053/server";
    //////////////////////////////////////////////////////////////////////

    const [UserId, setUserId] = useState('')


    async function GetUser() {
        setUserId(Moralis.User.current().attributes.ethAddress);
    }

    async function login() {
        let user = Moralis.User.current();
        if (!user) {
          user = await Moralis.authenticate();
        }
        GetUser();
      }

      async function logOut() {
        await Moralis.User.logOut();
        setUserId('')
      }

      useEffect(() => {
        Moralis.start({ serverUrl, appId });
        GetUser()
      }, [])
      
    return (
    <div><button onClick={login}>login</button>
    <button onClick={logOut}>logout</button>
    <p>{UserId}</p>
    </div>
    )
}