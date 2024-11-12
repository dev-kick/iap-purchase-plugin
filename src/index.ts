import type { IapPurchasePluginPlugin } from './definitions';
import { registerPlugin } from '@capacitor/core';

const IapPurchasePlugin = registerPlugin<IapPurchasePluginPlugin>('IapPurchasePlugin', {
  web: () => import('./web').then((m) => new m.IapPurchasePluginWeb()),
});

export * from './definitions';
export { IapPurchasePlugin };
