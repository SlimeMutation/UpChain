<template>
  <div >

    <button @click="connect"> 链接钱包 </button>
    <div>
    我的地址 : {{  account }}
  </div>
      <div class="block">
        Token 名称 : {{ name  }} , 
        Token 符号 : {{  symbol }} , 
        Token 精度 : {{  decimal }}
        <br /> Token 发行量 : {{  supply }} , 我的 Token 余额 : {{ balance  }}
        <br /> 我的ETH余额 : {{ ethbalance  }}
      </div>

      <div class="block">
      <h3>普通转账:</h3>
      <div >
        转账到:
        <input type="text" v-model="recipient" />
        <br />转账金额
        <input type="text" v-model="amount" />
        <br />
        <button @click="transfer"> 转账 </button>
      </div>
    </div>
    <div class="block">
      <h3>授权 存款(两笔交易):</h3>
      Bank合约地址：{{ bankAddress }}
      <div v-if="approved" >已授权额度: {{ approved }}</div>

      <div >
        <br />授权到:
        <input type="text" v-model="approveTo" />
        <br />金额
        <input type="text" v-model="approveAmount" />
        <br />
        
        <button @click="approve"> 授权 </button>
        <button @click="deposit"> 存款 </button>
      </div>
    </div>

    <div class="block">
      <h3>离线授权存款（一笔交易）</h3>
      <div >
        <input v-model="stakeAmount" placeholder="输入质押量"/>
        <button @click="permitDeposit">离线授权存款</button>
      </div>
    </div>

    <div class="block">
      <h3> 取款</h3>
      <div >
      我的存款：{{ myDeposit }}
      <button @click="withdraw">取款</button>
    </div>
  </div>

  </div>
</template>

<script>
import { ethers } from 'ethers'

import erc2612Addr from '../../deployments/dev/MyToken.json'
import erc2612Abi from '../../deployments/abi/MyToken.json'

import bankAddr from '../../deployments/dev/Vault.json'
import bankAbi from '../../deployments/abi/Vault.json'

export default {

  name: 'erc20',

  data() {
    return {
      signer: null,
      account: null,
      recipient: null,
      amount: null,
      balance: null,
      ethbalance: null,

      name: null,
      decimal: null,
      symbol: null,
      supply: null,

      stakeAmount: null,
      myDeposit: 0,
      approveTo: null,
      approveAmount: null,
      approved: null,
      bankAddress: bankAddr.address
    }
  },

  async created() {
  },

  methods: {
    async connect() {
      await this.initProvider()
      await this.initAccount()

      // 如果获取到了账号,进行合约初始化，并读取合约数据
      if (this.account) {
        this.initContract()
        this.readContract();
        this.getApproved();
      }
    },

    async initProvider(){
      if(window.ethereum) {
        this.provider = new ethers.BrowserProvider(window.ethereum);
        let network = await this.provider.getNetwork()
        this.chainId = network.chainId;
        console.log("chainId:", this.chainId);

      } else{
        console.log("Need install MetaMask")
      }
    },

    async initAccount(){
        try {
          this.accounts = await this.provider.send("eth_requestAccounts", []);
          console.log("accounts:" + this.accounts);
          this.account = this.accounts[0];

          // this.signer = this.provider.getSigner();
          this.signer = await this.provider.getSigner();
          console.log("signer:",await this.signer.getAddress());
        } catch(error){
            console.log("User denied account access", error)
        }
    },

    async initContract() {
      this.erc20Token = new ethers.Contract(erc2612Addr.address, 
        erc2612Abi, this.provider);

      this.bank = new ethers.Contract(bankAddr.address, 
        bankAbi, this.provider);

      this.erc20TokenWrite = new ethers.Contract(erc2612Addr.address, 
        erc2612Abi, await this.signer);

      this.bankWrite = new ethers.Contract(bankAddr.address, 
        bankAbi, await this.signer);

    }, 

    readContract() {
      this.provider.getBalance(this.account).then((r) => {
        this.ethbalance = ethers.formatEther(r);
      });

      this.erc20Token.name().then((r) => {
        this.name = r;
      })
      this.erc20Token.decimals().then((r) => {
        this.decimal = r;
      })
      this.erc20Token.symbol().then((r) => {
        this.symbol = r;
      })
      this.erc20Token.totalSupply().then((r) => {
        this.supply = ethers.formatUnits(r, 18);
      })

      this.erc20Token.balanceOf(this.account).then((r) => {
        this.balance = ethers.formatUnits(r, 18);
      })

      this.bank.accountBalanceOf(this.account).then((r) => {
        console.log('accountBalanceOf:', r);
        this.myDeposit = ethers.formatUnits(r, 18);
      })

    },

    getApproved() {
      this.erc20Token.allowance(this.account, this.bankAddress).then((r) => {
        this.approved = ethers.formatUnits(r, 18);
      })
    },
    

    // async transferEth() {
    //   let tx = await this.signer.sendTransaction({
    //     to: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
    //     value: ethers.parseEther("1.0")
    //   });
    // },

    transfer() {
      if (!this.erc20TokenWrite) {
        alert("先链接钱包")
      }
      let amount = ethers.parseUnits(this.amount, 18);
      
        this.erc20TokenWrite.transfer(this.recipient, amount).then((r) => {
          console.log(r);  // 返回值不是true
          this.readContract();
        }).catch(e => {
          alert("Error , please check the console log:", e)
        })

    },

    async approve() {
      if (!this.erc20TokenWrite) {
        alert("先链接钱包")
      }

      let amount = ethers.parseUnits(this.approveAmount, 18);
      let tx = await this.erc20TokenWrite.approve(this.approveTo, amount);
      await tx.wait();
      this.getApproved()
      // try {
      //   let amount = ethers.parseUnits(this.approveAmount, 18);
      //   let tx = await this.erc20TokenWrite.approve(this.approveTo, amount);
      //   await tx.wait();
      //   this.getApproved()
      // }
      // catch(e) {
      //     alert("Error , please check the console log:", e)
      // }
    },


    async deposit() {
      if (!this.bankWrite) {
        alert("先链接钱包")
      }

      let amount = ethers.parseUnits(this.approveAmount, 18);
      let tx = await this.bankWrite.deposit(amount);
      await tx.wait();
      this.getApproved();
      this.readContract();

      // try {
      //   let amount = ethers.parseUnits(this.approveAmount, 18);
      //   let tx = await this.bankWrite.deposit(amount);
      //   await tx.wait();
      //   this.getApproved();
      //   this.readContract();
      // }
      // catch(e) {
      //     alert("Error , please check the console log:", e)
      // }
    },

    async permitDeposit() {
      if (!this.erc20TokenWrite) {
        alert("先链接钱包")
      }

      let nonce = await this.erc20TokenWrite.nonces(this.account);
      this.deadline = Math.ceil(Date.now() / 1000) + parseInt(20 * 60);
      
      let amount =  ethers.parseUnits(this.stakeAmount).toString();
      
      const domain = {
          name: 'ERC2612',
          version: '1',
          chainId: this.chainId,
          verifyingContract: erc2612Addr.address
      }

      const types = {
          Permit: [
            {name: "owner", type: "address"},
            {name: "spender", type: "address"},
            {name: "value", type: "uint256"},
            {name: "nonce", type: "uint256"},
            {name: "deadline", type: "uint256"}
          ]
      }

      const message = {
          owner: this.account,
          spender: bankAddr.address,
          value: amount,
          nonce: nonce,
          deadline: this.deadline
      }

      const signature = await this.signer._signTypedData(domain, types, message);
      console.log(signature);

      const {v, r, s} = ethers.utils.splitSignature(signature);
      
      let tx = await this.bankWrite.permitDeposit(amount, this.deadline, v, r, s);
      let receipt = await tx.wait();
      this.readContract();

      // try {
      //   let tx = await this.bankWrite.permitDeposit(amount, this.deadline, v, r, s);
      //   let receipt = await tx.wait();
      //   this.readContract();
      // } catch (e) {
      //   alert("Error , please check the console log:", e)
      // }
      
    },

    async withdraw() {
      if (!this.bankWrite) {
        alert("先链接钱包")
      }

      let tx = await this.bankWrite.withdraw();
      await tx.wait();
      this.readContract();
    }
  }
}


</script>



<style scoped>
h1 {
  font-weight: 500;
  font-size: 2.6rem;
  top: -10px;
}

h3 {
  font-size: 1.4rem;
  color: firebrick;
}

.greetings h1,
.greetings h3 {
  text-align: center;
}

div {
  font-size: 1.2rem;
}

.block {
  margin: 5px;
  padding: 5px;
  border-style: solid;
  border-width: 1px;
}
</style>
