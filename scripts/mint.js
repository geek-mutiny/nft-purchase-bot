const Web3 = require('web3')
const web3 = new Web3('http://127.0.0.1:7545')

const nftContract = new web3.eth.Contract(ParentAbi, parentAddress)

const main = async () => {
    const [account] = await web3.eth.getAccounts()
    const utcDateTime = '2022-02-24T05:00:43Z'

    if (new Date(now).toISOString() == utcDateTime) {
        await nftContract.methods.buyMints()
    }
}

main()
