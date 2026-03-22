const root = typeof window !== 'undefined' ? window : globalThis;

export const BroadcastHubJQueryController = root.BroadcastHubJQueryController;
export const BroadcastHubSubscription = root.BroadcastHubSubscription;

export default {
  BroadcastHubJQueryController,
  BroadcastHubSubscription
};
