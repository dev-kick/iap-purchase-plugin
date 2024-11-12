export interface IapPurchasePluginPlugin {
  purchase(options: {
    productID: string;
    applicationUsername: string;
    appAccountToken: string;
  }): Promise<{ success: boolean; data?: any }>;
}
