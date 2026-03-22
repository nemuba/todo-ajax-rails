import BroadcastHubJQueryController from './jquery_controller';
import BroadcastHubSubscription from './subscription';

const root = typeof window !== 'undefined' ? window : globalThis;

if (root) {
  root.BroadcastHubJQueryController = BroadcastHubJQueryController;
  root.BroadcastHubSubscription = BroadcastHubSubscription;

  root.BroadcastHub = root.BroadcastHub || {};
  root.BroadcastHub.JQueryController = root.BroadcastHubJQueryController;
  root.BroadcastHub.Subscription = root.BroadcastHubSubscription;
}

export { BroadcastHubJQueryController, BroadcastHubSubscription };

export default {
  BroadcastHubJQueryController,
  BroadcastHubSubscription
};
