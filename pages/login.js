import { useEffect, useState } from 'react'
import Head from 'next/head'
import { Moralis } from 'moralis'

export default function userManage() {
    //////////////////////////////////////////////////////////////////////
    const appId = "vdgEX5APUMifU8c5dhB5F8Xm3bb8X5uGEa0LZRxf";
    const serverUrl = "https://6na6pzj82wfu.usemoralis.com:2053/server";
    //////////////////////////////////////////////////////////////////////
    const noUser = ''

    const [UserId, setUserId] = useState(noUser)


    async function GetUser() {
        setUserId(Moralis.User.current().attributes.ethAddress);
    }

    async function login() {
        let user = Moralis.User.current();
        if (!user) {
          user = await Moralis.authenticate({signingMessage:"Connect to Marketplace"});
        }
        GetUser();
      }
/*
      async function logOut() {
        await Moralis.User.logOut();
        setUserId(noUser)
      }
*/

      useEffect(() => {
        Moralis.start({ serverUrl, appId });
        let user = Moralis.User.current();
        if (!user) {
            setUserId(noUser)
          }else
          {
              GetUser()
            }
      }, [])
      
    return (
    <body class="blackBackground">
    <div class="loginFrame">
        <img className='loginFrameIco' src="logo2.svg"></img>
        <button class="btn-glow" onClick={login}><p id="loginButtonText">LOGIN</p></button>
    <p>{UserId}</p>
    </div></body>
    )
}