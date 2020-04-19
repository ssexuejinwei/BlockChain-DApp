import TutorialToken from './contracts/TutorialToken.json'
import ProvObject from './contracts/ProvObject.json'
import ProvEvent from './contracts/ProvEvent.json'
import ProvAgent from './contracts/ProvAgent.json'
import Strings from './contracts/Strings.json'

const options = {
  web3: {
    block: false,
    fallback: {
      type: 'ws',
      url: 'ws://127.0.0.1:9545'
    }
  },
  contracts: [TutorialToken, ProvObject, ProvEvent, ProvAgent,Strings],
  events: {
    SimpleStorage: ['StorageSet'],
	ProvObject:['ObjectSet','ObjectSetEvent','ObjectSetAgent']
  },
  polls: {
    accounts: 15000
  }
}

export default options
