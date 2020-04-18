import SimpleStorage from './contracts/SimpleStorage.json'
import ComplexStorage from './contracts/ComplexStorage.json'
import TutorialToken from './contracts/TutorialToken.json'
import ProvObject from './contracts/ProvObject.json'
import ProvEvent from './contracts/ProvEvent.json'
import ProvAgent from './contracts/ProvAgent.json'

const options = {
  web3: {
    block: false,
    fallback: {
      type: 'ws',
      url: 'ws://127.0.0.1:9545'
    }
  },
  contracts: [SimpleStorage, ComplexStorage, TutorialToken, ProvObject, ProvEvent, ProvAgent],
  events: {
    SimpleStorage: ['StorageSet'],
	ProvObject:['ObjectSet']
  },
  polls: {
    accounts: 15000
  }
}

export default options
