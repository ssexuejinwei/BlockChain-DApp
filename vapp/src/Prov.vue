<template>
	<el-tabs v-model="activeTabName">
	    <el-tab-pane label="创建记录" name="first">
			<div v-if="isDrizzleInitialized">
				<el-container>
					<el-header>
						<h1>上传资源</h1>
					</el-header>
					<el-main>
						<el-container>
							<el-header>
								<el-upload
									action="#"
								   class="upload-demo"
								  :show-file-list="true"
								  :limit="1"
								  :before-upload="beforeUpload"
								  :file-list="fileList"
								>
									<el-button size="small"  icon="el-icon-upload2" type="primary">文件</el-button>
								</el-upload>
							</el-header>
							<el-main>
								<div class = 'upload'>
									文件:{{this.file.name}}
									<br>
									<br>
									摘要:{{this.hash}}
									<br><br><br>

									<el-button type="danger" @click="submit"> 提交</el-button>
								</div>
								<!-- <el-form ref="form" :model="form" label-width="80px">
								  <el-form-item label="文件" >
									<el-input v-model="form.name" disabled></el-input>
								  </el-form-item>
								  <el-form-item label="摘要">
									<el-input v-model="form.hash" disabled></el-input>
								  </el-form-item>
								</el-form>
								<el-button type="danger" @click="submit"> 提交</el-button> -->
							</el-main>
						</el-container>
					</el-main>
				</el-container>
				<el-divider></el-divider>
				<div v-if="click" class = "content">
					<div class = 'object'>
						{{this.object.hash}} -类别: {{this.object.category}}
						<br><br>
						{{this.object.hash}} -格式: {{this.object.format}}
						<br><br>
						No.Properties: {{this.object.properties.length}}
						<br><br><br>
					</div>
					<div class = 'events'>
						<h3>活动信息</h3>
						No.Events: {{this.object.events.length}}
						<br><br><br>
					</div>
					<div class = 'agents'>
						<h3>代理信息</h3>
						No.Agents: {{this.object.agents.length}}
						<br><br><br>
					</div>
				</div>
				<!-- 合约部分 -->
				<!-- <drizzle-contract-form
				  v-if="click"
				  contractName="ProvObject"
				  method="setObject"
				  :placeholders="placeholders"
				  :methodArgs = "objectSetArgs"
				/>
				<p>
					{{accounts}}
				</p> -->
				<!-- <drizzle-contract
					contractName="TutorialToken"
					method="totalSupply"
					label="Total"
				  />
				  <drizzle-contract
					contractName="TutorialToken"
					method="symbol"
					label="Symbol"
				  />
				  <drizzle-contract
					contractName="TutorialToken"
					method="balanceOf"
					label="Your Balance"
					:methodArgs="accounts"
				  />
					<p> i am here</p>
					
					<drizzle-contract-form
					  contractName="ProvObject"
					  method="setObject"
					  :placeholders="placeholders"
					/>
					<p>可以自己运行的</p>
					<drizzle-contract-form
					  contractName="ProvObject"
					  method="getObject"
					  label="getObject"
					  :methodArgs="array"
					/> -->
			</div>
			<div v-else>Loading...</div>
		</el-tab-pane>
	    <el-tab-pane label="获取记录" name="second">上传文件</el-tab-pane>
	</el-tabs>
    
</template>

<script>
import { mapGetters } from 'vuex'
import CryptoJS from "crypto-js";
import Base64 from 'crypto-js/enc-base64';
export default {
  name: 'TutorialToken',
  computed: {
    ...mapGetters('accounts', ['activeAccount', 'activeBalance']),
    ...mapGetters('drizzle', ['isDrizzleInitialized','drizzleInstance']),
	...mapGetters('contracts', ['getContractData']),
	get_uintarray() {
	  return this.getContractData({
	    contract: 'ProvObject',
	    method: 'getObject'
	  })
	},
    accounts() {
      return [this.activeAccount]
    },
	array(){
		return [0];
	},
    placeholders() {
      return ['object摘要', '类别','格式']
    }
  },
  mounted() {
  	this.$drizzleEvents.$on('drizzle/contractEvent', payload => {
  	  const { contractName, eventName, data } = payload
  	  // Do something with payload data
	  // console.log('iamhere',data)
  	})
  },
  watch: {
  	fileList(newValue, oldValue) {
  		console.log(newValue)
  	}
  },
  created() {
  	  console.log(this.drizzleInstance)
	  let drizzle = this.drizzleInstance
	  const dataKey1 = drizzle.contracts.ProvObject.methods.getNumObject().call().then((response) => {
		  console.log(response)
		  for (let i=0; i<response;i++){
			  drizzle.contracts.ProvObject.methods.getObject(i).call().then((response) =>{
				  console.log(response)
			  })
		  }
	  })
	  // const dataKey1 = drizzle.contracts.SimpleStorage.methods.set(2).send({from:'0x01FA6852D2ebA066F8c79c9540BD767E3B1f8b7B'})
	  // const dataKey1 = drizzle.contracts.SimpleStorage.methods.set.cacheSend(2,{from:'0x01FA6852D2ebA066F8c79c9540BD767E3B1f8b7B'})
	  // const dataKey = drizzle.contracts.SimpleStorage.methods.storedData().call()
	      // Use the dataKey to display data from the store.
	      // console.log( dataKey1)
  	  // this.drizzleInstance.contracts.SimpleStorage.methods.set(1).call()
  },
  data() {
  	return {
  		activeTabName: "first",
		fileList: [],
		fileHash:[] ,//fileText:'',hash:''
		hash:"",
		form:{},
		file:{},
		objectSetArgs:[],
		click : false,
		object:{}
  	}
  },
  
  methods: {
	submit() {
		if (this.hash === "") {
			this.$alert("请先上传文件")
			return
		}
		this.click = true
		let account = this.activeAccount
		let drizzle = this.drizzleInstance
		// const dataKey1 = drizzle.contracts.ProvObject.methods.getObject(0).call().then((response) => {
		// 		  console.log(response,response)
		// })
		// const dataKey1 = drizzle.contracts.SimpleStorage.methods.set(2).send({from:'0x01FA6852D2ebA066F8c79c9540BD767E3B1f8b7B'})
		//get methods
		let objectMethods = drizzle.contracts.ProvObject.methods
		let agentMethods = drizzle.contracts.ProvAgent.methods
		let eventMethods = drizzle.contracts.ProvEvent.methods
		//set object
		objectMethods.setObject(this.hash,this.file.name,this.file.name.split('.')[1]).send({from:account}).then((response) => {
			drizzle.contracts.ProvObject.methods.getObject(this.hash).call().then((response) => {
				console.log(response)
				this.object = {
					hash:this.hash,
					properties:response.properties,
					events:response.events,
					agents:response.agents,
					category: response.category,
					format:response.format
				}
			})
		})

		
		//set agent
		//set event
	},
	beforeUpload(file) {
		this.read(file)
		this.file = file
	},
	read(f) {
		let rd = new FileReader();
		rd.readAsBinaryString(f);
		// rd.readAsText(f, 'UTF-8');
		rd.onload = e => {  
			//this.readAsArrayBuffer函数内，会回调this.onload函数。在这里处理结果
			let file = e.target.result //file->filetext
			console.log(file)
			if (this.fileHash.length == 0) {
				const hash = CryptoJS.SHA3(file).toString()
				this.fileHash.push({
					file: file,
					hash: hash
				})
				this.hash = hash
			}
			else {
				let flag = false
				for (let i = 0; i<this.fileHash.length; i++) {
					let data = this.fileHash[i]
					let existsFile = data.file
					if(file.indexOf(existsFile) !== -1) {
						//存在子串
						this.hash = data.hash
						this.fileHash[i].file = file
						flag = true
						break
					}
				}
				if(flag === false) {
					//说明不存在子串,新增一个对应关系
					const hash = CryptoJS.SHA3(file).toString()
					this.fileHash.push({
						file: file,
						hash: hash
					})
					this.hash = hash
				}
			}
			this.form = {
				name:this.file.name,
				hash : this.hash
			}
		}
	}
  },
}
</script>

<style></style>
