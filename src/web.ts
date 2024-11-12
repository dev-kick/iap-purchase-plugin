/* eslint-disable import/order */
import type { IapPurchasePluginPlugin } from './definitions';
import { WebPlugin } from '@capacitor/core';

export class IapPurchasePluginWeb extends WebPlugin implements IapPurchasePluginPlugin {
  async purchase(): Promise<{ success: boolean; data?: any }> {
    const data = {}; // Define the data variable
    return { success: true, data };
  }
}
