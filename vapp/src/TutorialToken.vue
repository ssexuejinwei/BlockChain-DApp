<template>
  <div v-if="isDrizzleInitialized">
    <drizzle-contract
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
	<!-- <drizzle-contract
      contractName="ProvObject"
      method="objects"
      label="objects"
    /> -->
	<drizzle-contract-form
	  contractName="ProvObject"
	  method="setObject"
	  :placeholders="placeholders"
	/>
	<p>可以自己运行的</p>
	<!-- <drizzle-contract-form
	  contractName="ProvObject"
	  method="setObject"
	  :placeholders="placeholders"
	  :methodArgs="array"
	/> -->
	<drizzle-contract-form
	  contractName="ProvObject"
	  method="getObject"
	  label="getObject"
	  :methodArgs="array"
	/>
  </div>

  <div v-else>Loading...</div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'TutorialToken',
  computed: {
    ...mapGetters('accounts', ['activeAccount', 'activeBalance']),
    ...mapGetters('drizzle', ['isDrizzleInitialized']),

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
	  console.log('iamhere',data)
  	})
  }
}
</script>

<style></style>
