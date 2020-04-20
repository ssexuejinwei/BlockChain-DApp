<template>
	<div>
		<el-radio-group v-model="radio">
			<el-radio-button label="1">创建记录</el-radio-button>
			<el-radio-button label="2">获取记录</el-radio-button>
		</el-radio-group>
		<div v-if="isDrizzleInitialized">
			<el-container>
				<el-header>
					<h1>上传资源</h1>
				</el-header>
				<el-main>
					<el-container>
						<el-header>
							<el-upload action="#" class="upload-demo" :show-file-list="true" :limit="1" :before-upload="beforeUpload"
							 :file-list="fileList">
								<el-button size="small" icon="el-icon-upload2" type="primary">文件</el-button>
							</el-upload>
						</el-header>
						<el-main>
							<div class='upload'>
								文件:{{file.name}}
								<br>
								<br>
								摘要:{{hash}}
								<br><br><br>
								<el-row>
									<el-col :span="5">
										
										<el-button v-if="radio == 1 ?true:false" type="danger" @click="submit"> 提交</el-button>
										<el-button v-else type="danger" @click="submit"> 查看</el-button>
									</el-col>
									<el-col :span="5">
										<el-button type="success" @click="dialogVisible=true" :disabled="JSON.stringify(object) === '{}'?true:false">操作</el-button>
									</el-col>
								</el-row>
							</div>
						</el-main>
					</el-container>
				</el-main>
			</el-container>
			<el-divider></el-divider>
			<div v-if="click" class="content">
				<div  class="object">
					{{object.hash}} -类别: {{object.category}}
					<br><br>
					{{object.hash}} -格式: {{object.format}}
					<br><br>
					No.Properties: {{object.properties.length}}
					<div v-for="prop in object.properties">
						{{object.hash}}&nbsp;-属性:&nbsp;{{prop.propType}}--{{prop.propValue}}
						<br>
					</div>
					<br><br><br>
				</div>
				<div class='events'>
					<h3>活动信息</h3>
					No.Events: {{object.events.length}}
					<div v-for="data in object.events">
						{{object.hash}}&nbsp;-活动id:&nbsp;{{data}}
						<br>
					</div>
					<div v-for="event in events">
						{{event.eventId}}&nbsp;-活动对象:&nbsp;{{event.objectHash}}<br>
						{{event.eventId}}&nbsp;-活动类型:&nbsp;{{event.EventType}}<br>
						{{event.eventId}}&nbsp;-活动代理:&nbsp;{{event.agentId}}<br>
						{{event.eventId}}&nbsp;-活动时间:&nbsp;{{event.time}}<br>
					</div>
					<br><br><br>
				</div>
				<div class='agents'>
					<h3>代理信息</h3>
					No.Agents: {{object.agents.length}}
					<div v-for="data in object.agents">
						{{object.hash}}&nbsp;-代理id:&nbsp;{{data}}
					</div>
					<div v-for="agent in agents">
						{{agent.agentId}}&nbsp;-代理名字:&nbsp;{{agent.name}}
						{{agent.agentId}}&nbsp;-代理类型:&nbsp;{{agent.agentType}}
					</div>
					<br><br><br>
				</div>
			</div>
		</div>
		<div v-else>Loading...</div>
		<el-dialog title="操作" :visible.sync="dialogVisible">
			ObjectHash<el-input v-model="object.hash"></el-input>
			<br><br><br>
			AgentId
			<el-input v-model="activeAccount"></el-input>
			<br><br><br>
			<el-divider></el-divider>
			<el-select v-model="value" filterable placeholder="请选择">
				<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
				</el-option>
			</el-select>
			<div v-if="value ==='setProperties' ">
				<p>设置实体属性</p>
				<drizzle-contract-form contractName="ProvObject" method="setProperties" />
			</div>
			<div v-if="value ==='setEvent' ">
				<p>设置事件</p>
				<p>事件ID：{{object.events}}</p>
				<drizzle-contract-form contractName="ProvObject" method="setEvent" />
				<br><br>
				<drizzle-contract-form contractName="ProvEvent" method="setEvent" />
			</div>
			<div v-if="value ==='setAgent' ">
				<p>设置代理</p>
				<p>代理ID：{{object.agentId}}</p>
				<drizzle-contract-form contractName="ProvObject" method="setAgent"  />
				<br><br>
				<drizzle-contract-form contractName="ProvAgent" method="setAgent" />
			</div>
			<span slot="footer" class="dialog-footer">
				<el-button type="primary" @click="editEnsure()">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
	import {
		mapGetters
	} from 'vuex'
	import CryptoJS from "crypto-js";
	import Base64 from 'crypto-js/enc-base64';
	export default {
		name: 'TutorialToken',
		computed: {
			...mapGetters('accounts', ['activeAccount', 'activeBalance']),
			...mapGetters('drizzle', ['isDrizzleInitialized', 'drizzleInstance']),
			...mapGetters('contracts', ['getContractData']),
			accounts() {
				return [this.activeAccount]
			},
		},
		mounted() {
			this.$drizzleEvents.$on('drizzle/contractEvent', payload => {
				const {
					contractName,
					eventName,
					data
				} = payload
				// Do something with payload data
				// console.log('iamhere',payload)
				if (contractName == 'ProvObject' && eventName == 'ObjectSetEvent') {
					this.eventID = data._eventId
				}
			})
		},
		watch: {
			radio(newValue, oldValue) {
				this.click = false;
				// console.log(newValue)
			}
		},
		created() {
			this.accountId = CryptoJS.SHA256(this.activeAccount).toString()
		},
		data() {
			return {
				radio: 1,
				accountId:"",
				activeTabName: "first",
				fileList: [],
				fileHash: [], //fileText:'',hash:''
				hash: "",
				file: {},
				objectSetArgs: [],
				click: false,
				object: {},
				eventID: '',
				agents: [],
				events: [],
				dialogVisible: false,
				options: [{
					value: 'setProperties',
					label: 'setProperties'
				}, {
					value: 'setEvent',
					label: 'setEvent'
				},{
					value: 'setAgent',
					label: 'setAgent'
				}],
				value: ''
			}
		},

		methods: {
			editEnsure() {
				this.getObject()
				this.dialogVisible = false
			},
			submit() {
				if (this.hash === "") {
					this.$alert("请先上传文件")
					return
				}
				console.log('i am here submit')
				let account = this.activeAccount
				let drizzle = this.drizzleInstance

				let objectMethods = drizzle.contracts.ProvObject.methods
				let agentMethods = drizzle.contracts.ProvAgent.methods
				let eventMethods = drizzle.contracts.ProvEvent.methods
				//set object
				if (this.radio == 1) {
					// console.log(typeof(this.hash))
					// console.log('i am here set')
					objectMethods.setObject(this.hash, this.file.name, this.file.name.split('.')[1]).send({
						from: account
					}).then((response) => {
						console.log(response)
						this.getObject()
						this.click = true
					})
				} else {
					console.log('i am here get')
					// this.getEvents()
					this.getObject()
					this.click = true
				}
			},
			getObject() {
				let drizzle = this.drizzleInstance
				drizzle.contracts.ProvObject.methods.getObject(this.hash).call().then((response) => {
					console.log(response)
					this.object = {
						hash: this.hash,
						properties: response.properties,
						events: response.events,
						agents: response.agents,
						category: response.category,
						format: response.format
					}
					console.log('object', this.object)
					this.getEvents()
					this.getAgents()
				})
			},
			getEvents() {
				let drizzle = this.drizzleInstance
				console.log('event', this.object.events)
				this.events = []
				for (let eventId of this.object.events) {
					drizzle.contracts.ProvEvent.methods.getEvent(eventId).call().then((response) => {
						this.events.push({
							objectHash: response.objectHash,
							agentId: response.agentId,
							time: response.time,
							eventId: eventId,
							EventType: response.EventType
						})
					})
				}

			},
			getAgents() {
				let drizzle = this.drizzleInstance
				this.agents = []
				console.log('agent', this.object.agents)
				for (let agentId of this.object.agents) {
					drizzle.contracts.ProvAgent.methods.getAgent(agentId).call().then((response) => {
						this.agents.push({
							agentId:agentId,
							objects: response.objects,
							events: response.events,
							name: response.name,
							agentType: response.agentType
						})
					})
				}
			},
			beforeUpload(file) {
				this.read(file)
				console.log('file',file)
				this.file = file
			},
			read(f) {
				let rd = new FileReader();
				rd.readAsBinaryString(f);
				// rd.readAsText(f, 'UTF-8');
				rd.onload = e => {
					//this.readAsArrayBuffer函数内，会回调this.onload函数。在这里处理结果
					let file = e.target.result //file->filetext
					// console.log(file)
					if (this.fileHash.length == 0) {
						const hash = CryptoJS.SHA3(file).toString()
						// const hash = CryptoJS.SHA256(file).toString()
						this.fileHash.push({
							file: file,
							hash: hash
						})
						this.hash = hash
					} else {
						let flag = false
						for (let i = 0; i < this.fileHash.length; i++) {
							let data = this.fileHash[i]
							let existsFile = data.file
							if (file.indexOf(existsFile) !== -1) {
								//存在子串
								this.hash = data.hash
								this.fileHash[i].file = file
								flag = true
								break
							}
						}
						if (flag === false) {
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
						name: this.file.name,
						hash: this.hash
					}
				}
			}
		},
	}
</script>

<style></style>
