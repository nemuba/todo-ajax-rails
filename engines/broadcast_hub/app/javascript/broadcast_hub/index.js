import BroadcastHubJQueryController from './jquery_controller';
import BroadcastHubSubscription from './subscription';

const root = typeof window !== 'undefined' ? window : globalThis;

if (root) {
  root.BroadcastHubJQueryController = root.BroadcastHubJQueryController || BroadcastHubJQueryController;
  root.BroadcastHubSubscription = root.BroadcastHubSubscription || BroadcastHubSubscription;
}

export { BroadcastHubJQueryController, BroadcastHubSubscription };

export default {
  BroadcastHubJQueryController,
  BroadcastHubSubscription
};
