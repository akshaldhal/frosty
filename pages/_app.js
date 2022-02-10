/* pages/_app.js */
import '../styles/globals.css'
import '../styles/custom.css'
import Link from 'next/link'

//add feature to make "sell nft page link" visible and invisible acording to signer
//make broken tree to fixed tree animation for login page


export default function Loader({ Component, pageProps }) {
    return (
      <div>
      <nav className="border-b p-3 bg-slate-700">
        <p className="text-4xl font-bold text-sky-100">Unnamed</p>
        <div className="flex mt-4">
          <Link href="/">
            <a className="mr-4 text-sky-400">
              Home
            </a>
          </Link>
          <Link href="/create-item">
            <a className="mr-6 text-sky-400">
              Sell Digital Asset
            </a>
          </Link>
          <Link href="/my-assets">
            <a className="mr-6 text-sky-400">
              My Digital Assets
            </a>
          </Link>
        </div>
      </nav>
      <Component {...pageProps} />
    </div>
    )
  }